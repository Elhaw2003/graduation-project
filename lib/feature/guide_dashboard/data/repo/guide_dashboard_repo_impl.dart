import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
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
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo.dart';

class GuideDashboardRepoImpl implements GuideDashboardRepo {
  final ApiConsumer apiConsumer;

  GuideDashboardRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, GuideDashboardModel>> getDashboard() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboard);
      return Right(GuideDashboardModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideStatisticsModel>> getStatistics() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardStatistics);
      return Right(GuideStatisticsModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideDocumentsModel>> getDocuments() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardDocuments);
      return Right(GuideDocumentsModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyEarningModel>>> getEarnings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardEarnings);
      final list = (response as List)
          .map((e) => MonthlyEarningModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyBookingModel>>> getBookings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardBookings);
      final list = (response as List)
          .map((e) => MonthlyBookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<TourPerformanceModel>>>
  getToursPerformance() async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardToursPerformance,
      );
      final list = (response as List)
          .map((e) => TourPerformanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideWalletModel>> getWallet() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardWallet);
      return Right(GuideWalletModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionModel>>>
  getWalletTransactions() async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardWalletTransactions,
      );
      final list = (response as List)
          .map(
            (e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<RecentActivityModel>>> getActivities() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardActivities);
      final list = (response as List)
          .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<GuideTourSummaryModel>>> getMyTours() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardMyTours);
      final list = (response as List)
          .map((e) => GuideTourSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideTourDetailModel>> getTourDetails({
    required String id,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardTour(id: id),
      );
      return Right(GuideTourDetailModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<TourByPlaceModel>>> getToursByPlace({
    required String placeId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardTourByPlace(placeId: placeId),
      );
      final list = (response as List)
          .map((e) => TourByPlaceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTour({required String id}) async {
    try {
      final response = await apiConsumer.delete(
        EndPoint.guideDashboardTour(id: id),
      );
      final message = (response is Map)
          ? response['message'] as String? ?? ''
          : '';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<GuideBookingModel>>> getGuideBookings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideBookings);
      final list = (response as List)
          .map((e) => GuideBookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> createTour({
    required Map<String, dynamic> tourData,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.guideDashboardTourCreate,
        data: tourData,
      );
      final message = (response is Map)
          ? response['message'] as String? ?? 'Tour created successfully'
          : 'Tour created successfully';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> editTour({
    required String id,
    required Map<String, dynamic> tourData,
  }) async {
    try {
      final response = await apiConsumer.put(
        EndPoint.guideDashboardTourEdit(id: id),
        data: tourData,
      );
      final message = (response is Map)
          ? response['message'] as String? ?? 'Tour updated successfully'
          : 'Tour updated successfully';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }
}
