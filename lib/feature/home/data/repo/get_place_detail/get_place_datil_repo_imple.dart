import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datail_repo.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';

class GetPlaceDetailRepoImple implements GetPlaceDatailRepo {
  final ApiConsumer apiConsumer;

  GetPlaceDetailRepoImple({required this.apiConsumer});

  @override
  Future<Either<Failure, PlaceModel>> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      // 1. Check internet connectivity
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // 2. Fetch place details from the API
      final response = await apiConsumer.get(
        EndPoint.getPlaceDetails(id: placeId),
      );

      // 3. Parse JSON into PlaceModel
      final placeDetail = PlaceModel.fromJson(response);

      return Right(placeDetail);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
