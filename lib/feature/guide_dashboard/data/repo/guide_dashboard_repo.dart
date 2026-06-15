import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_dashboard_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_documents_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_statistics_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_detail_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_summary_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_wallet_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_earning_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/recent_activity_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_by_place_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_performance_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/wallet_transaction_model.dart';

abstract class GuideDashboardRepo {
  Future<Either<Failure, GuideDashboardModel>> getDashboard();

  Future<Either<Failure, GuideStatisticsModel>> getStatistics();

  Future<Either<Failure, GuideDocumentsModel>> getDocuments();

  Future<Either<Failure, List<MonthlyEarningModel>>> getEarnings();

  Future<Either<Failure, List<MonthlyBookingModel>>> getBookings();

  Future<Either<Failure, List<TourPerformanceModel>>> getToursPerformance();

  Future<Either<Failure, GuideWalletModel>> getWallet();

  Future<Either<Failure, List<WalletTransactionModel>>> getWalletTransactions();

  Future<Either<Failure, List<RecentActivityModel>>> getActivities();

  Future<Either<Failure, List<GuideTourSummaryModel>>> getMyTours();

  Future<Either<Failure, GuideTourDetailModel>> getTourDetails({
    required String id,
  });

  Future<Either<Failure, List<TourByPlaceModel>>> getToursByPlace({
    required String placeId,
  });

  Future<Either<Failure, String>> deleteTour({required String id});

  Future<Either<Failure, String>> createTour({
    required Map<String, dynamic> tourData,
  });

  Future<Either<Failure, String>> editTour({
    required String id,
    required Map<String, dynamic> tourData,
  });

  Future<Either<Failure, List<GuideBookingModel>>> getGuideBookings();
}
