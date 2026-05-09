// places_state.dart



import 'package:smart_guide/feature/home/data/get_places/get_places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesSuccess extends PlacesState {
  final List<PlaceModel> places;
  final int count;

  PlacesSuccess({required this.places, required this.count});
}

class PlacesError extends PlacesState {
  final String message;

  PlacesError(this.message);
}
