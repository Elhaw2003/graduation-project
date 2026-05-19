class TourDetailsModel {
  final String id;
  final String title;
  final String description;
  final int durationHours;
  final double price;
  final List<String> images;
  final List<StopModel> stops;
  final List<InclusionModel> inclusions;

  TourDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationHours,
    required this.price,
    required this.images,
    required this.stops,
    required this.inclusions,
  });

  factory TourDetailsModel.fromJson(Map<String, dynamic> json) {
    return TourDetailsModel(
      id: json['id'],

      title: json['title'],

      description: json['description'],

      durationHours: json['durationHours'],

      price: (json['price'] as num).toDouble(),

      images: List<String>.from(json['images']),

      stops: (json['stops'] as List).map((e) => StopModel.fromJson(e)).toList(),

      inclusions: (json['inclusions'] as List)
          .map((e) => InclusionModel.fromJson(e))
          .toList(),
    );
  }
}

class StopModel {
  final int orderIndex;
  final String title;
  final String description;

  StopModel({
    required this.orderIndex,
    required this.title,
    required this.description,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      orderIndex: json['orderIndex'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class InclusionModel {
  final String description;
  final String type;

  InclusionModel({required this.description, required this.type});

  factory InclusionModel.fromJson(Map<String, dynamic> json) {
    return InclusionModel(description: json['description'], type: json['type']);
  }
}
