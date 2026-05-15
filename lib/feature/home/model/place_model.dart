class PlaceModel {
  final int id;
  final String name;
  final String type;
  final String description;
  final String location;
  final String city;
  final String governorate;
  final String imageUrl;
  final num rating;
  final String historicalBackground;
  final String createdBy;
  final String period;
  final int? startYear;

  PlaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.city,
    required this.governorate,
    required this.imageUrl,
    required this.rating,
    required this.historicalBackground,
    required this.createdBy,
    required this.period,
    this.startYear,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      /// 🔥 أهم سطر هنا
      id: json['id'] ?? json['placeId'] ?? 0,

      name: json['name'] ?? 'Unknown Place',
      type: json['type'] ?? 'Unknown Type',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating'] ?? 0,
      historicalBackground: json['historicalBackground'] ?? '',
      createdBy: json['createdBy'] ?? '',
      period: json['period'] ?? '',
      startYear: json['startYear'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'description': description,
    'location': location,
    'city': city,
    'governorate': governorate,
    'imageUrl': imageUrl,
    'rating': rating,
    'historicalBackground': historicalBackground,
    'createdBy': createdBy,
    'period': period,
    'startYear': startYear,
  };
}
