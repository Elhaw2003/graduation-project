import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';

abstract class SavedGuidesRepository {
  Future<Either<Failure, List<SavedGuideModel>>> getSavedGuides();
  Future<Either<Failure, String>> saveGuide({required String guideId});
  Future<Either<Failure, String>> removeSavedGuide({required String guideId});
}
