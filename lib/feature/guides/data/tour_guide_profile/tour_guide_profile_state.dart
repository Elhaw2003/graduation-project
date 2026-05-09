import 'package:equatable/equatable.dart';
import 'package:smart_guide/feature/guides/model/tour_guide_profile_model.dart';

abstract class TourGuideProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TourGuideProfileInitial extends TourGuideProfileState {}

class TourGuideProfileLoading extends TourGuideProfileState {}

class TourGuideProfileSuccess extends TourGuideProfileState {
  final TourGuideProfileModel profile;

  TourGuideProfileSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class TourGuideProfileError extends TourGuideProfileState {
  final String message;

  TourGuideProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
