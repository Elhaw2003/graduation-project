import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/edit_guide_profile/edit_guide_profile_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class EditGuideProfileRepoImpl implements EditGuideProfileRepo {
  final ApiConsumer apiConsumer;

  EditGuideProfileRepoImpl({required this.apiConsumer});

  @override
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
  }) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final formData = FormData();

      formData.fields.addAll([
        MapEntry('FirstName', firstName),
        MapEntry('LastName', lastName),
        MapEntry('Country', country),
        MapEntry('WhatsAppNumber', whatsAppNumber),
        MapEntry('Bio', bio),
        MapEntry('PricePerDay', pricePerDay.toString()),
      ]);

      for (final city in cities) {
        formData.fields.add(MapEntry('Cities', city));
      }

      for (final language in languages) {
        formData.fields.add(MapEntry('Languages', language));
      }

      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        final file = File(profilePicturePath);
        if (await file.exists()) {
          formData.files.add(
            MapEntry(
              'ProfilePicture',
              await MultipartFile.fromFile(
                profilePicturePath,
                filename: profilePicturePath.split(Platform.pathSeparator).last,
              ),
            ),
          );
        }
      }

      if (retainedGalleryUrls != null) {
        for (final url in retainedGalleryUrls) {
          if (url.isNotEmpty) {
            formData.fields.add(MapEntry('ExistingGallery', url));
          }
        }
      }

      if (newGalleryPaths != null) {
        for (final path in newGalleryPaths) {
          if (path.isEmpty) continue;
          final file = File(path);
          if (await file.exists()) {
            formData.files.add(
              MapEntry(
                'Gallery',
                await MultipartFile.fromFile(
                  path,
                  filename: path.split(Platform.pathSeparator).last,
                ),
              ),
            );
          }
        }
      }

      final response = await apiConsumer.put(
        EndPoint.tourGuideProfile(id: id),
        data: formData,
      );

      return Right(
        TourGuideModel.fromJson(response as Map<String, dynamic>),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
