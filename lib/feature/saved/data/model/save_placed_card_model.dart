import 'package:flutter/material.dart';

class SavedPlaceedCardModel {
  const SavedPlaceedCardModel({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
  final String tag;
  final String title;
  final String subtitle;
  final String imageUrl;
}

class SavedCategoryModel {
  const SavedCategoryModel({required this.title, required this.icon});
  final String title;
  final IconData icon;
}
