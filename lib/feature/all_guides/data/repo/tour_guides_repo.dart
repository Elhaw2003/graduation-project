import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../model/tour_guide_model.dart';

abstract class TourGuidesRepository {
  Future<Either<Failure, List<TourGuideModel>>> getTourGuides();
  Future<Either<Failure, TourGuideModel>> getTourGuideProfile(String id);
}