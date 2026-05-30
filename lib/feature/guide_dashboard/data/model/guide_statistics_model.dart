class GuideStatisticsModel {
  final double walletBalance;
  final double totalEarnings;
  final double pendingEarnings;
  final int totalTours;
  final int activeTours;
  final int inactiveTours;
  final int upcomingTours;
  final int cancelledTours;
  final int completedTours;
  final int totalTouristsServed;
  final int totalUniqueTourists;
  final double monthlyRevenue;
  final int pendingWithdrawals;
  final String verificationStatus;
  final String accountStatus;
  final double averageRating;
  final int totalReviews;
  final bool reviewsDataAvailable;

  const GuideStatisticsModel({
    required this.walletBalance,
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.totalTours,
    required this.activeTours,
    required this.inactiveTours,
    required this.upcomingTours,
    required this.cancelledTours,
    required this.completedTours,
    required this.totalTouristsServed,
    required this.totalUniqueTourists,
    required this.monthlyRevenue,
    required this.pendingWithdrawals,
    required this.verificationStatus,
    required this.accountStatus,
    required this.averageRating,
    required this.totalReviews,
    required this.reviewsDataAvailable,
  });

  factory GuideStatisticsModel.fromJson(Map<String, dynamic> json) {
    return GuideStatisticsModel(
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      pendingEarnings: (json['pendingEarnings'] as num?)?.toDouble() ?? 0.0,
      totalTours: json['totalTours'] as int? ?? 0,
      activeTours: json['activeTours'] as int? ?? 0,
      inactiveTours: json['inactiveTours'] as int? ?? 0,
      upcomingTours: json['upcomingTours'] as int? ?? 0,
      cancelledTours: json['cancelledTours'] as int? ?? 0,
      completedTours: json['completedTours'] as int? ?? 0,
      totalTouristsServed: json['totalTouristsServed'] as int? ?? 0,
      totalUniqueTourists: json['totalUniqueTourists'] as int? ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
      pendingWithdrawals: json['pendingWithdrawals'] as int? ?? 0,
      verificationStatus: json['verificationStatus'] as String? ?? '',
      accountStatus: json['accountStatus'] as String? ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      reviewsDataAvailable: json['reviewsDataAvailable'] as bool? ?? false,
    );
  }
}
