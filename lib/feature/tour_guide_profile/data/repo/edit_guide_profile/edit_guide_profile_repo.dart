import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';

abstract class EditGuideProfileRepo {
  Future<Either<Failure, TourGuideModel>> updateGuideProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    required String bio,
    required double pricePerDay,
    required List<String> cities,
    required List<String> languages,
    String? profilePicturePath,
    List<String>? retainedGalleryUrls,
    List<String>? newGalleryPaths,
  });
}
