import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/booking_payment/data/model/booking_model.dart';
import 'package:smart_guide/feature/booking_payment/data/model/cancel_booking_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/create_booking_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/payment_intent_response.dart';
import 'package:smart_guide/feature/booking_payment/data/model/tour_slot_model.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo.dart';

class BookingPaymentRepoImpl implements BookingPaymentRepo {
  final ApiConsumer apiConsumer;

  BookingPaymentRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<TourSlotModel>>> fetchAvailableTourSlots({
    required String tourId,
    String? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null && date.isNotEmpty) {
        queryParams['date'] = date;
      }
      final response = await apiConsumer.get(
        EndPoint.tourSlots(tourId: tourId),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final list = (response as List)
          .map((e) => TourSlotModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, CreateBookingResponse>> createBooking({
    required String tourId,
    required String slotId,
    required List<String> selectedAddOnIds,
    required int paymentMethod,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.createBooking,
        data: {
          'tourId': tourId,
          'slotId': slotId,
          'selectedAddOnIds': selectedAddOnIds,
          'paymentMethod': paymentMethod,
        },
      );
      final parsed = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      return Right(CreateBookingResponse.fromJson(parsed));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, PaymentIntentResponse>> createPaymentIntent({
    required String bookingId,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.paymentCreateIntent,
        data: {'bookingId': bookingId},
      );
      final parsed = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      return Right(PaymentIntentResponse.fromJson(parsed));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<BookingModel>>> fetchMyBookings() async {
    try {
      final response = await apiConsumer.get(EndPoint.myBookings);
      final list = (response as List)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, CancelBookingResponse>> cancelBooking({
    required String bookingId,
  }) async {
    try {
      final response = await apiConsumer.delete(
        EndPoint.cancelBooking(bookingId: bookingId),
      );
      final parsed = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      return Right(CancelBookingResponse.fromJson(parsed));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }
}
