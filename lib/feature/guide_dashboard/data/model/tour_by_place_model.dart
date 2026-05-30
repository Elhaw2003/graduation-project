class TourByPlaceModel {
  final String id;
  final String title;
  final double price;
  final int durationHours;
  final String imageUrl;

  const TourByPlaceModel({
    required this.id,
    required this.title,
    required this.price,
    required this.durationHours,
    required this.imageUrl,
  });

  factory TourByPlaceModel.fromJson(Map<String, dynamic> json) {
    return TourByPlaceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationHours: json['durationHours'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
