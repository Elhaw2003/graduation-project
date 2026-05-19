class TourModel {
  final String id;
  final String title;
  final double price;
  final int durationHours;
  final String primaryImage;

  TourModel({
    required this.id,
    required this.title,
    required this.price,
    required this.durationHours,
    required this.primaryImage,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      durationHours: json['durationHours'],
      primaryImage: json['primaryImage'],
    );
  }
}
