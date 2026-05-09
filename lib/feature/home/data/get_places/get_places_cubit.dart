// places_cubit.dart

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guide/feature/home/data/get_places/get_places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit() : super(PlacesInitial());

  List<PlaceModel> _allPlaces = [];
  List<PlaceModel> _filteredPlaces = [];

  Future<void> getPlaces() async {
    emit(PlacesLoading());

    try {
      final response = await http.get(
        Uri.parse('https://smartguide.runasp.net/api/Places'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final List placesList = jsonData['data'];

        _allPlaces = placesList.map((e) => PlaceModel.fromJson(e)).toList();

        _filteredPlaces = _allPlaces;

        emit(
          PlacesSuccess(places: _filteredPlaces, count: _filteredPlaces.length),
        );
      } else {
        emit(PlacesError("Failed"));
      }
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }

  void searchPlaces(String query) {
    if (query.isEmpty) {
      _filteredPlaces = _allPlaces;

      emit(
        PlacesSuccess(places: _filteredPlaces, count: _filteredPlaces.length),
      );
      return;
    }

    _filteredPlaces = _allPlaces
        .where(
          (place) => place.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    emit(PlacesSuccess(places: _filteredPlaces, count: _filteredPlaces.length));
  }
}

class PlaceModel {
  final int id;
  final String name;
  final String imageUrl;
  final int rating;

  PlaceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      rating: json['rating'],
    );
  }
}
