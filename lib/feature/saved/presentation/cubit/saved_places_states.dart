import 'package:equatable/equatable.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';

abstract class SavedPlacesState extends Equatable {
  const SavedPlacesState();

  @override
  List<Object?> get props => [];
}

class SavedPlacesInitial extends SavedPlacesState {}

class SavedPlacesLoading extends SavedPlacesState {}

class SavedPlacesSuccess extends SavedPlacesState {
  final Set<int> savedIds;
  final List<PlaceModel> places;

  const SavedPlacesSuccess(this.savedIds, {this.places = const []});

  @override
  List<Object?> get props => [savedIds, places];
}

class SavePlaceSuccess extends SavedPlacesState {
  final Set<int> savedIds;
  final String message;

  const SavePlaceSuccess({required this.savedIds, required this.message});

  @override
  List<Object?> get props => [savedIds, message];
}

class RemovePlaceSuccess extends SavedPlacesState {
  final Set<int> savedIds;
  final String message;

  const RemovePlaceSuccess({required this.savedIds, required this.message});

  @override
  List<Object?> get props => [savedIds, message];
}

class SavedPlacesFailure extends SavedPlacesState {
  final String message;

  const SavedPlacesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
