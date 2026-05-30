class GuideTourDetailModel {
  final String id;
  final String title;
  final String description;
  final int durationHours;
  final double price;
  final List<String> images;
  final List<TourStopModel> stops;
  final List<TourInclusionModel> inclusions;
  final List<TourAddOnModel> addOns;

  const GuideTourDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationHours,
    required this.price,
    required this.images,
    required this.stops,
    required this.inclusions,
    required this.addOns,
  });

  factory GuideTourDetailModel.fromJson(Map<String, dynamic> json) {
    return GuideTourDetailModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      durationHours: json['durationHours'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List?)
              ?.map((e) => e as String? ?? '')
              .toList() ??
          [],
      stops: (json['stops'] as List?)
              ?.map((e) => TourStopModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      inclusions: (json['inclusions'] as List?)
              ?.map((e) =>
                  TourInclusionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      addOns: (json['addOns'] as List?)
              ?.map((e) => TourAddOnModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TourStopModel {
  final String stopName;
  final int durationMinutes;

  const TourStopModel({
    required this.stopName,
    required this.durationMinutes,
  });

  factory TourStopModel.fromJson(Map<String, dynamic> json) {
    return TourStopModel(
      stopName: json['stopName'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
    );
  }
}

class TourInclusionModel {
  final String item;

  const TourInclusionModel({required this.item});

  factory TourInclusionModel.fromJson(Map<String, dynamic> json) {
    return TourInclusionModel(
      item: json['item'] as String? ?? '',
    );
  }
}

class TourAddOnModel {
  final String title;
  final double price;

  const TourAddOnModel({
    required this.title,
    required this.price,
  });

  factory TourAddOnModel.fromJson(Map<String, dynamic> json) {
    return TourAddOnModel(
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
