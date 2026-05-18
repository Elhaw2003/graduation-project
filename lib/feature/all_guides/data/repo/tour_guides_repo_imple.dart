import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo.dart';

class TourGuidesRepositoryImpl implements TourGuidesRepository {
  final ApiConsumer apiConsumer;

  TourGuidesRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<TourGuideModel>>> getTourGuides() async {
    try {
      // 1. Check internet connectivity
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // 2. Fetch data from the API
      final response = await apiConsumer.get(EndPoint.tourGuides);

      // 3. Parse JSON Array into List of Models
      final List<dynamic> data = response as List<dynamic>;
      final tourGuides = data
          .map((json) => TourGuideModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(tourGuides);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TourGuideModel>> getTourGuideProfile(String id) async {
    try {
      // 1. Check internet connectivity
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // 2. Fetch data from the API
      final response = await apiConsumer.get(
        '${EndPoint.tourGuides}/$id/profile',
      );

      // 3. Parse JSON Map into Model
      final tourGuide = TourGuideModel.fromJson(
        response as Map<String, dynamic>,
      );

      return Right(tourGuide);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
