import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';

abstract class SavedPlacesRepo {
  Future<Either<Failure, String>> savePlace({required int placeId});

  Future<Either<Failure, String>> removeSavedPlace({required int placeId});

  Future<Either<Failure, List<PlaceModel>>> getSavedPlaces();
}
