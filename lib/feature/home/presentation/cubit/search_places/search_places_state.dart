import 'package:smart_guide/feature/home/model/place_model.dart';

abstract class SearchPlacesState {}

class SearchPlacesInitial extends SearchPlacesState {}

class SearchPlacesLoading extends SearchPlacesState {}

class SearchPlacesPaginationLoading extends SearchPlacesState {}

class SearchPlacesSuccess extends SearchPlacesState {
  final List<PlaceModel> places;
  final bool hasReachedMax;

  SearchPlacesSuccess({required this.places, required this.hasReachedMax});
}

class SearchPlacesFailure extends SearchPlacesState {
  final String errorMessage;

  SearchPlacesFailure(this.errorMessage);
}
