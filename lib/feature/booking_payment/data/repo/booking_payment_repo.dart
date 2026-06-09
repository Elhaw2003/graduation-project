import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/booking_payment/data/model/booking_model.dart';
import 'package:smart_guide/feature/booking_payment/data/model/cancel_booking_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/create_booking_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/payment_intent_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/tour_slot_model.dart';

abstract class BookingPaymentRepo {
  Future<Either<Failure, List<TourSlotModel>>> fetchAvailableTourSlots({
    required String tourId,
    String? date,
  });

  Future<Either<Failure, CreateBookingResponse>> createBooking({
    required String tourId,
    required String slotId,
    required List<String> selectedAddOnIds,
    required int paymentMethod,
  });

  Future<Either<Failure, PaymentIntentResponse>> createPaymentIntent({
    required String bookingId,
  });

  Future<Either<Failure, List<BookingModel>>> fetchMyBookings();

  Future<Either<Failure, CancelBookingResponse>> cancelBooking({
    required String bookingId,
  });
}
