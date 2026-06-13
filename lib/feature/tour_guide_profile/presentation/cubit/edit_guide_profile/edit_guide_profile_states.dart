import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';

abstract class EditGuideProfileState {
  const EditGuideProfileState();
}

class EditGuideProfileInitial extends EditGuideProfileState {}

class EditGuideProfileLoading extends EditGuideProfileState {}

class EditGuideProfileSuccess extends EditGuideProfileState {
  final TourGuideModel profile;
  final String message;

  const EditGuideProfileSuccess({
    required this.profile,
    required this.message,
  });
}

class EditGuideProfileFailure extends EditGuideProfileState {
  final String errorMessage;

  const EditGuideProfileFailure({required this.errorMessage});
}
