import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/book_now/data/booknow/book_now_service.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_state.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_details_model.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';

class BookNowCubit extends Cubit<BookNowStates> {
  BookNowCubit(this.bookNowService) : super(BookNowInitial());

  final BookNowService bookNowService;

  /// =========================
  /// STEPS
  /// =========================

  int currentStep = 1;

  void goToScheduleStep() {
    currentStep = 2;

    emit(BookNowInitial());
  }

  void goToPaymentStep(DateTime date, String time) {
    selectedDate = date;

    bookingTime = time;

    currentStep = 3;

    emit(BookNowInitial());
  }

  void backToToursStep() {
    currentStep = 1;

    emit(BookNowInitial());
  }

  /// =========================
  /// BOOKING DATA
  /// =========================

  DateTime? selectedDate;

  String? bookingTime;

  void setBookingDate(DateTime date) {
    selectedDate = date;

    emit(BookNowInitial());
  }

  void setBookingTime(String time) {
    bookingTime = time;

    emit(BookNowInitial());
  }

  /// =========================
  /// TOURS LIST
  /// =========================

  List<TourModel> tours = [];

  Future<void> getGuideTours({required String guideId}) async {
    emit(BookNowLoading());

    try {
      final response = await bookNowService.getGuideTours(guideId: guideId);

      tours = response;

      emit(BookNowSuccess(response));
    } catch (e) {
      emit(BookNowFailure(e.toString()));
    }
  }

  /// =========================
  /// TOUR DETAILS
  /// =========================

  TourDetailsModel? selectedTour;

  String? selectedTourId;

  Future<void> getTourDetails({required String tourId}) async {
    /// close if already opened
    if (selectedTourId == tourId) {
      selectedTourId = null;

      selectedTour = null;

      emit(BookNowInitial());

      return;
    }

    emit(TourDetailsLoading());

    try {
      final details = await bookNowService.getTourDetails(tourId: tourId);

      selectedTourId = tourId;

      selectedTour = details;

      emit(TourDetailsSuccess(details));
    } catch (e) {
      emit(TourDetailsFailure(e.toString()));
    }
  }
}
