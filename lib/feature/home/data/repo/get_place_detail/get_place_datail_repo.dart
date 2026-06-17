import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';

abstract class GetPlaceDatailRepo {
  Future<Either<Failure, PlaceModel>> getPlaceDetails({
    required String placeId,
  });
  Future<Either<Failure, String>> ratePlace({
    required String placeId,
    required int rating,
    String? review,
  });
}
