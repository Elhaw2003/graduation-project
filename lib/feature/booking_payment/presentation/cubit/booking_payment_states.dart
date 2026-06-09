import 'package:smart_guide/feature/booking_payment/data/model/booking_model.dart';
import 'package:smart_guide/feature/booking_payment/data/model/tour_slot_model.dart';

abstract class BookingPaymentState {}

class BookingPaymentInitial extends BookingPaymentState {}

// Tour Slots
class TourSlotsLoading extends BookingPaymentState {}

class TourSlotsSuccess extends BookingPaymentState {
  final List<TourSlotModel> slots;
  TourSlotsSuccess(this.slots);
}

class TourSlotsFailure extends BookingPaymentState {
  final String errorMessage;
  TourSlotsFailure(this.errorMessage);
}

// Create Booking
class CreateBookingLoading extends BookingPaymentState {}

class CreateBookingSuccess extends BookingPaymentState {
  final String bookingId;
  CreateBookingSuccess(this.bookingId);
}

class CreateBookingFailure extends BookingPaymentState {
  final String errorMessage;
  CreateBookingFailure(this.errorMessage);
}

// Payment / Stripe
class PaymentIntentLoading extends BookingPaymentState {}

class PaymentSheetReady extends BookingPaymentState {}

class PaymentSuccess extends BookingPaymentState {}

class PaymentFailure extends BookingPaymentState {
  final String errorMessage;
  PaymentFailure(this.errorMessage);
}

// My Bookings
class MyBookingsLoading extends BookingPaymentState {}

class MyBookingsSuccess extends BookingPaymentState {
  final List<BookingModel> bookings;
  MyBookingsSuccess(this.bookings);
}

class MyBookingsFailure extends BookingPaymentState {
  final String errorMessage;
  MyBookingsFailure(this.errorMessage);
}

// Cancel Booking
class CancelBookingLoading extends BookingPaymentState {}

class CancelBookingSuccess extends BookingPaymentState {
  final String message;
  CancelBookingSuccess(this.message);
}

class CancelBookingFailure extends BookingPaymentState {
  final String errorMessage;
  CancelBookingFailure(this.errorMessage);
}
