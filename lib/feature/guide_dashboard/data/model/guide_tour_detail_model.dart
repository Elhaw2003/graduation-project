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
      durationHours: (json['durationHours'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List?)
              ?.map((e) => e as String? ?? '')
              .toList() ??
          [],
      stops: (json['stops'] as List?)
              ?.map((e) => TourStopModel.fromJson(
                    e is Map<String, dynamic> ? e : <String, dynamic>{},
                  ))
              .toList() ??
          [],
      inclusions: (json['inclusions'] as List?)
              ?.map((e) => TourInclusionModel.fromJson(
                    e is Map<String, dynamic> ? e : <String, dynamic>{},
                  ))
              .toList() ??
          [],
      addOns: (json['addOns'] as List?)
              ?.map((e) => TourAddOnModel.fromJson(
                    e is Map<String, dynamic> ? e : <String, dynamic>{},
                  ))
              .toList() ??
          [],
    );
  }
}

// Backend shape: {"Title":"...","Description":"...","orderIndex":1,"PlaceId":1}
class TourStopModel {
  final String title;
  final String description;
  final int orderIndex;
  final int placeId;

  const TourStopModel({
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.placeId,
  });

  factory TourStopModel.fromJson(Map<String, dynamic> json) {
    return TourStopModel(
      title: (json['title'] ?? json['Title'] ?? json['stopName'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? json['Description'] ?? '').toString(),
      orderIndex: (json['orderIndex'] ?? json['OrderIndex'] ?? json['order'] ?? 0 as num).toInt(),
      placeId: (json['placeId'] ?? json['PlaceId'] ?? 0 as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Title': title,
        'Description': description,
        'orderIndex': orderIndex,
        'PlaceId': placeId,
      };
}

// Backend shape: {"Description":"...","Type":"Included|Excluded"}
class TourInclusionModel {
  final String description;
  final String type; // "Included" or "Excluded"

  const TourInclusionModel({
    required this.description,
    required this.type,
  });

  factory TourInclusionModel.fromJson(Map<String, dynamic> json) {
    return TourInclusionModel(
      description: (json['description'] ??
              json['Description'] ??
              json['title'] ??
              json['item'] ??
              '')
          .toString(),
      type: (json['type'] ?? json['Type'] ?? 'Included').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Description': description,
        'Type': type,
      };
}

// Backend shape: {"Title":"...","Price":50}
class TourAddOnModel {
  final String title;
  final double price;

  const TourAddOnModel({
    required this.title,
    required this.price,
  });

  factory TourAddOnModel.fromJson(Map<String, dynamic> json) {
    return TourAddOnModel(
      title: (json['title'] ?? json['Title'] ?? '').toString(),
      price: ((json['price'] ?? json['Price'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Title': title,
        'Price': price,
      };
}
