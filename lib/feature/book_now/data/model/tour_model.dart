class TourModel {
  final String id;
  final String title;
  final int durationHours;
  final int maxGroupSize;
  final double price;
  final String primaryImage;

  TourModel({
    required this.id,
    required this.title,
    required this.durationHours,
    required this.maxGroupSize,
    required this.price,
    required this.primaryImage,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'],
      title: json['title'],
      durationHours: json['durationHours'],
      maxGroupSize: json['maxGroupSize'],
      price: (json['price'] as num).toDouble(),
      primaryImage: json['primaryImage'],
    );
  }
}
