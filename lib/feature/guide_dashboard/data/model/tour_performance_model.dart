class TourPerformanceModel {
  final String tourId;
  final String title;
  final int totalBookings;
  final int confirmedBookings;
  final int cancelledBookings;
  final double revenue;
  final double occupancyRate;

  const TourPerformanceModel({
    required this.tourId,
    required this.title,
    required this.totalBookings,
    required this.confirmedBookings,
    required this.cancelledBookings,
    required this.revenue,
    required this.occupancyRate,
  });

  factory TourPerformanceModel.fromJson(Map<String, dynamic> json) {
    return TourPerformanceModel(
      tourId: json['tourId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      totalBookings: json['totalBookings'] as int? ?? 0,
      confirmedBookings: json['confirmedBookings'] as int? ?? 0,
      cancelledBookings: json['cancelledBookings'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      occupancyRate: (json['occupancyRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
