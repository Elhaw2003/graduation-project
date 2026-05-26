import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';

abstract class TouristProfileState {}

class TouristProfileInitial extends TouristProfileState {}

class TouristProfileLoading extends TouristProfileState {}

class TouristProfileSuccess extends TouristProfileState {
  final TouristProfileModel profile;
  TouristProfileSuccess(this.profile);
}

class TouristProfileUpdateLoading extends TouristProfileState {}

class TouristProfileUpdateSuccess extends TouristProfileState {
  final TouristProfileModel profile;
  final String message;
  TouristProfileUpdateSuccess(this.profile, this.message);
}

class TouristProfileFailure extends TouristProfileState {
  final String errorMessage;
  TouristProfileFailure(this.errorMessage);
}
