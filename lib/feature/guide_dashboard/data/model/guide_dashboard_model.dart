import 'package:smart_guide/feature/guide_dashboard/data/model/guide_statistics_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_earning_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/recent_activity_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_performance_model.dart';

class GuideDashboardModel {
  final GuideStatisticsModel statistics;
  final List<MonthlyEarningModel> monthlyEarnings;
  final List<MonthlyBookingModel> monthlyBookings;
  final List<TourPerformanceModel> mostPopularTours;
  final List<TourPerformanceModel> leastActiveTours;
  final List<RecentActivityModel> recentActivities;

  const GuideDashboardModel({
    required this.statistics,
    required this.monthlyEarnings,
    required this.monthlyBookings,
    required this.mostPopularTours,
    required this.leastActiveTours,
    required this.recentActivities,
  });

  factory GuideDashboardModel.fromJson(Map<String, dynamic> json) {
    return GuideDashboardModel(
      statistics: GuideStatisticsModel.fromJson(
        json['statistics'] as Map<String, dynamic>? ?? {},
      ),
      monthlyEarnings: (json['monthlyEarnings'] as List?)
              ?.map((e) =>
                  MonthlyEarningModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyBookings: (json['monthlyBookings'] as List?)
              ?.map((e) =>
                  MonthlyBookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mostPopularTours: (json['mostPopularTours'] as List?)
              ?.map((e) =>
                  TourPerformanceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      leastActiveTours: (json['leastActiveTours'] as List?)
              ?.map((e) =>
                  TourPerformanceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentActivities: (json['recentActivities'] as List?)
              ?.map((e) =>
                  RecentActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
