import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';

abstract class TourGuidesState {
  const TourGuidesState();
}

class TourGuidesInitial extends TourGuidesState {}

class TourGuidesLoading extends TourGuidesState {}

class TourGuidesFailure extends TourGuidesState {
  final String errorMessage;
  const TourGuidesFailure({required this.errorMessage});
}

class TourGuidesSuccess extends TourGuidesState {
  final List<TourGuideModel> tourGuides;
  const TourGuidesSuccess({required this.tourGuides});
}

class GuideDetailsSuccess extends TourGuidesState {
  final TourGuideModel tourGuide;
  const GuideDetailsSuccess({required this.tourGuide});
}
