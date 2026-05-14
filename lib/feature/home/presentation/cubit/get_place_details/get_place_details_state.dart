import 'package:smart_guide/feature/home/model/place_model.dart';

abstract class GetPlaceDetailsState {}

class GetPlaceDetailsInitial extends GetPlaceDetailsState {}

class GetPlaceDetailsLoading extends GetPlaceDetailsState {}

class GetPlaceDetailsSuccess extends GetPlaceDetailsState {
  final PlaceModel place;

  GetPlaceDetailsSuccess({required this.place});
}

class GetPlaceDetailsFailure extends GetPlaceDetailsState {
  final String errorMessage;

  GetPlaceDetailsFailure({required this.errorMessage});
}