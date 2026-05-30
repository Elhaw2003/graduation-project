class GuideTourSummaryModel {
  final String id;
  final String title;
  final int durationHours;
  final int maxGroupSize;
  final double price;
  final String primaryImage;

  const GuideTourSummaryModel({
    required this.id,
    required this.title,
    required this.durationHours,
    required this.maxGroupSize,
    required this.price,
    required this.primaryImage,
  });

  factory GuideTourSummaryModel.fromJson(Map<String, dynamic> json) {
    return GuideTourSummaryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationHours: json['durationHours'] as int? ?? 0,
      maxGroupSize: json['maxGroupSize'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      primaryImage: json['primaryImage'] as String? ?? '',
    );
  }
}
