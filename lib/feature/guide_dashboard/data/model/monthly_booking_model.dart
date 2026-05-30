class MonthlyBookingModel {
  final int year;
  final int month;
  final int totalBookings;
  final int confirmedBookings;
  final int cancelledBookings;

  const MonthlyBookingModel({
    required this.year,
    required this.month,
    required this.totalBookings,
    required this.confirmedBookings,
    required this.cancelledBookings,
  });

  factory MonthlyBookingModel.fromJson(Map<String, dynamic> json) {
    return MonthlyBookingModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      totalBookings: json['totalBookings'] as int? ?? 0,
      confirmedBookings: json['confirmedBookings'] as int? ?? 0,
      cancelledBookings: json['cancelledBookings'] as int? ?? 0,
    );
  }
}
