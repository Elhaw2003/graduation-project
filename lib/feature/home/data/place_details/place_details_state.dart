part of 'place_details_cubit.dart';

abstract class PlaceDetailsState {}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsSuccess extends PlaceDetailsState {
  final PlaceDetailsModel place;

  PlaceDetailsSuccess({required this.place});
}

class PlaceDetailsError extends PlaceDetailsState {
  final String message;

  PlaceDetailsError(this.message);
}