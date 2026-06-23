import 'package:flutter/material.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';

class SavedPlaceedCardModel {
  const SavedPlaceedCardModel({
    required this.rating,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.placeId,
  });

  final num rating;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int placeId;

  factory SavedPlaceedCardModel.fromPlaceModel(PlaceModel place) {
    return SavedPlaceedCardModel(
      rating: place.rating,
      title: place.name,
      subtitle: place.description,
      imageUrl: place.imageUrl,
      placeId: place.id,
    );
  }
}

class SavedCategoryModel {
  const SavedCategoryModel({required this.title, required this.icon});
  final String title;
  final IconData icon;
}
