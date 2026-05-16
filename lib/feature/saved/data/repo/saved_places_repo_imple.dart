import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/saved/data/repo/saved_places_repo.dart';

class SavedPlacesRepoImpl implements SavedPlacesRepo {
  final ApiConsumer apiConsumer;

  SavedPlacesRepoImpl({required this.apiConsumer});

  /// ================= SAVE PLACE =================
  @override
  Future<Either<Failure, String>> savePlace({required int placeId}) async {
    try {
      await apiConsumer.post(EndPoint.savedPlaces, data: {"placeId": placeId});

      return const Right("Place saved successfully");
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  /// ================= REMOVE PLACE =================
  @override
  Future<Either<Failure, String>> removeSavedPlace({
    required int placeId,
  }) async {
    try {
      await apiConsumer.delete("${EndPoint.savedPlaces}/$placeId");

      return const Right("Place removed successfully");
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  /// ================= GET SAVED PLACES =================
  @override
  Future<Either<Failure, List<PlaceModel>>> getSavedPlaces() async {
    try {
      final response = await apiConsumer.get(EndPoint.savedPlaces);

      final List<PlaceModel> places = (response as List).map((e) {
        return PlaceModel.fromJson({...e, "id": e["placeId"], "isSaved": true});
      }).toList();

      return Right(places);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }
}
