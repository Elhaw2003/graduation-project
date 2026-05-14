import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/home/model/places_model.dart';

abstract class GetPlacesRepo {
  Future<Either<Failure, PlacesPaginationModel>> getPlaces({
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
  });
}
