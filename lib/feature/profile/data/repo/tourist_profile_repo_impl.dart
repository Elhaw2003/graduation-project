import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/profile/data/repo/tourist_profile_repo.dart';

class TouristProfileRepoImpl implements TouristProfileRepo {
  final ApiConsumer apiConsumer;

  TouristProfileRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, TouristProfileModel>> getTouristProfile({
    required String id,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.touristProfile(id: id),
      );
      return Right(TouristProfileModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, TouristProfileModel>> updateTouristProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    String? imagePath,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'FirstName': firstName,
        'LastName': lastName,
        'Country': country,
        'WhatsAppNumber': whatsAppNumber,
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        formMap['TouristImage'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await apiConsumer.put(
        EndPoint.touristProfile(id: id),
        data: formData,
      );
      return Right(TouristProfileModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }
}
