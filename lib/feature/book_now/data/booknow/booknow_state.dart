import 'package:smart_guide/feature/book_now/data/model/tour_details_model.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';

abstract class BookNowStates {}

class BookNowInitial extends BookNowStates {}

class BookNowLoading extends BookNowStates {}

class BookNowSuccess extends BookNowStates {
  final List<TourModel> tours;

  BookNowSuccess(this.tours);
}

class BookNowFailure extends BookNowStates {
  final String errorMessage;

  BookNowFailure(this.errorMessage);
}class TourDetailsLoading extends BookNowStates {}

class TourDetailsSuccess extends BookNowStates {
  final TourDetailsModel details;

  TourDetailsSuccess(this.details);
}

class TourDetailsFailure extends BookNowStates {
  final String error;

  TourDetailsFailure(this.error);
}