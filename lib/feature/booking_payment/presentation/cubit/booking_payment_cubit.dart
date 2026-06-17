import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_guide/feature/booking_payment/data/model/tour_slot_model.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class BookingAndPaymentCubit extends Cubit<BookingPaymentState> {
  final BookingPaymentRepo bookingPaymentRepo;

  BookingAndPaymentCubit({required this.bookingPaymentRepo})
    : super(BookingPaymentInitial());

  // Cached data for step navigation
  List<TourSlotModel> availableSlots = [];
  TourSlotModel? selectedSlot;

  // Anti-duplicate booking reservation cache
  // Maps a composite key "tourId_slotId" to its existing bookingId
  final Map<String, String> _reservationCache = {};

  // ==============================================
  // Reservation Cache Key Generator
  // ==============================================
  String _buildReservationKey(String tourId, String slotId) =>
      '${tourId}_$slotId';

  // ==============================================
  // Check if a booking reservation already exists
  // ==============================================
  String? checkExistingBookingReservation({
    required String tourId,
    required String slotId,
  }) {
    final key = _buildReservationKey(tourId, slotId);
    return _reservationCache[key];
  }

  // ==============================================
  // 1. Fetch Available Tour Slots
  // ==============================================
  Future<void> fetchAvailableTourSlots({
    required String tourId,
    String? date,
  }) async {
    emit(TourSlotsLoading());
    final result = await bookingPaymentRepo.fetchAvailableTourSlots(
      tourId: tourId,
      date: date,
    );
    result.fold((failure) => emit(TourSlotsFailure(failure.message)), (slots) {
      availableSlots = slots;
      emit(TourSlotsSuccess(slots));
    });
  }

  void selectSlot(TourSlotModel slot) {
    selectedSlot = slot;
    emit(BookingPaymentInitial());
  }

  // ==============================================
  // 2. Stripe Payment Gateway Flow (Online = 2)
  //    With Anti-Duplicate Booking Prevention
  // ==============================================
  Future<void> executeStripePaymentGatewayFlow({
    required String tourId,
    required String slotId,
  }) async {
    final existingBookingId = checkExistingBookingReservation(
      tourId: tourId,
      slotId: slotId,
    );

    if (existingBookingId != null && existingBookingId.isNotEmpty) {
      // Bypass booking creation and proceed directly to payment intent
      await _initiateStripePaymentSheet(bookingId: existingBookingId);
      return;
    }

    // Phase 1: Create a fresh booking reservation
    emit(CreateBookingLoading());
    final bookingResult = await bookingPaymentRepo.createBooking(
      tourId: tourId,
      slotId: slotId,
      selectedAddOnIds: [],
      paymentMethod: 2, // Online Payment (Stripe)
    );

    await bookingResult.fold(
      (failure) async => emit(CreateBookingFailure(failure.message)),
      (bookingResponse) async {
        if (!bookingResponse.isSuccess || bookingResponse.bookingId.isEmpty) {
          emit(CreateBookingFailure(bookingResponse.message));
          return;
        }

        // Cache the bookingId to prevent duplicate creation
        final key = _buildReservationKey(tourId, slotId);
        _reservationCache[key] = bookingResponse.bookingId;

        // Phase 2: Proceed to Stripe payment
        await _initiateStripePaymentSheet(bookingId: bookingResponse.bookingId);
      },
    );
  }

  // ==============================================
  // Internal: Stripe Payment Sheet Initialization
  // ==============================================
  Future<void> _initiateStripePaymentSheet({required String bookingId}) async {
    emit(PaymentIntentLoading());
    final intentResult = await bookingPaymentRepo.createPaymentIntent(
      bookingId: bookingId,
    );

    await intentResult.fold(
      (failure) async => emit(PaymentFailure(failure.message)),
      (intentResponse) async {
        if (!intentResponse.isSuccess || intentResponse.clientSecret.isEmpty) {
          emit(PaymentFailure(intentResponse.message));
          return;
        }

        try {
          // Stripe.publishableKey = intentResponse.publishableKey;

          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: intentResponse.clientSecret,
              merchantDisplayName: LocaleKeys.appName.tr(),
              style: ThemeMode.system,
            ),
          );

          emit(PaymentSheetReady());

          await Stripe.instance.presentPaymentSheet();

          // Payment completed: clear reservation cache
          _reservationCache.removeWhere((key, value) => value == bookingId);

          emit(PaymentSuccess());
        } on StripeException catch (e) {
          if (e.error.code == FailureCode.Canceled) {
            emit(PaymentFailure('Payment cancelled'));
          } else {
            emit(PaymentFailure(e.error.localizedMessage ?? 'Payment failed'));
          }
        } catch (e) {
          emit(PaymentFailure('Payment failed'));
        }
      },
    );
  }

  // ==============================================
  // 3. Cash Booking Flow (Cash = 1)
  //    With Anti-Duplicate Booking Prevention
  // ==============================================
  Future<void> executeCashBookingFlow({
    required String tourId,
    required String slotId,
  }) async {
    final existingBookingId = checkExistingBookingReservation(
      tourId: tourId,
      slotId: slotId,
    );

    if (existingBookingId != null && existingBookingId.isNotEmpty) {
      // Already created before, emit success directly
      emit(PaymentSuccess());
      return;
    }

    emit(CreateBookingLoading());
    final result = await bookingPaymentRepo.createBooking(
      tourId: tourId,
      slotId: slotId,
      selectedAddOnIds: [],
      paymentMethod: 1, // Cash Payment
    );
    result.fold((failure) => emit(CreateBookingFailure(failure.message)), (
      response,
    ) {
      if (response.isSuccess) {
        // Cache the bookingId
        final key = _buildReservationKey(tourId, slotId);
        _reservationCache[key] = response.bookingId;
        emit(PaymentSuccess());
      } else {
        emit(CreateBookingFailure(response.message));
      }
    });
  }

  // ==============================================
  // 4. Fetch Tourist Active Bookings (My Trips)
  // ==============================================
  Future<void> fetchTouristActiveBookings() async {
    emit(MyBookingsLoading());
    final result = await bookingPaymentRepo.fetchMyBookings();
    result.fold(
      (failure) => emit(MyBookingsFailure(failure.message)),
      (bookings) => emit(MyBookingsSuccess(bookings)),
    );
  }

  // ==============================================
  // 5. Cancel Existing Booking
  // ==============================================
  Future<void> cancelExistingBooking({required String bookingId}) async {
    emit(CancelBookingLoading());
    final result = await bookingPaymentRepo.cancelBooking(bookingId: bookingId);
    result.fold((failure) => emit(CancelBookingFailure(failure.message)), (
      response,
    ) {
      if (response.isSuccess) {
        // Clear from reservation cache
        _reservationCache.removeWhere((key, value) => value == bookingId);
        emit(CancelBookingSuccess(response.message));
        fetchTouristActiveBookings();
      } else {
        emit(CancelBookingFailure(response.message));
      }
    });
  }

  // ==============================================
  // 6. Clear all reservation cache (logout/reset)
  // ==============================================
  void clearReservationCache() {
    _reservationCache.clear();
  }
}
