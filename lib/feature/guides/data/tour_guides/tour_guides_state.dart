import 'package:smart_guide/feature/guides/model/tour_guides_model.dart';

abstract class TourGuidesState {}

class TourGuidesInitial extends TourGuidesState {}

class TourGuidesLoading extends TourGuidesState {}

class TourGuidesSuccess extends TourGuidesState {
  final List<TourGuideModel> guides;

  TourGuidesSuccess(this.guides);
}

class TourGuidesError extends TourGuidesState {
  final String message;

  TourGuidesError(this.message);
}
