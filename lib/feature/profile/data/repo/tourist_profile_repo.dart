import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';

abstract class TouristProfileRepo {
  Future<Either<Failure, TouristProfileModel>> getTouristProfile({
    required String id,
  });

  Future<Either<Failure, TouristProfileModel>> updateTouristProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    String? imagePath,
  });
}
