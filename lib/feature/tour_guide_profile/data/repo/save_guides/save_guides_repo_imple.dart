import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo.dart';

class SavedGuidesRepositoryImpl implements SavedGuidesRepository {
  final ApiConsumer apiConsumer;

  SavedGuidesRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<SavedGuideModel>>> getSavedGuides() async {
    try {
      // Check internet connectivity first
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // Fetch saved guides from API
      final response = await apiConsumer.get(EndPoint.savedGuides);

      // Parse JSON Array into List of Models
      final List<dynamic> data = response as List<dynamic>;
      final savedGuides = data
          .map((json) => SavedGuideModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(savedGuides);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveGuide({required String guideId}) async {
    try {
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      final response = await apiConsumer.post(
        EndPoint.savedGuides,
        data: {'guideId': guideId},
      );

      if (response is Map<String, dynamic> && response['isSuccess'] == true) {
        return Right(response['message'] ?? 'Guide saved successfully');
      } else {
        return Left(
          ServerFailure(response['message'] ?? 'Failed to save tour guide'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> removeSavedGuide({
    required String guideId,
  }) async {
    try {
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      final response = await apiConsumer.delete(
        EndPoint.deleteSavedGuide(guideId: guideId),
      );

      if (response is Map<String, dynamic> && response['isSuccess'] == true) {
        return Right(response['message'] ?? 'Guide removed successfully');
      } else {
        return Left(
          ServerFailure(response['message'] ?? 'Failed to remove tour guide'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
