import 'package:smart_guide/feature/home/model/place_model.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesPaginationLoading extends PlacesState {}

class PlacesSuccess extends PlacesState {
  final List<PlaceModel> places;
  final bool hasReachedMax;

  PlacesSuccess({required this.places, required this.hasReachedMax});
}

class PlacesFailure extends PlacesState {
  final String errorMessage;

  PlacesFailure(this.errorMessage);
}
