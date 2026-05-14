import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo.dart';
import 'package:smart_guide/feature/home/model/places_model.dart';

class GetPlacesRepoImple implements GetPlacesRepo {
  final ApiConsumer apiConsumer;

  GetPlacesRepoImple({required this.apiConsumer});

  @override
  Future<Either<Failure, PlacesPaginationModel>> getPlaces({
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      /// 1. التحقق من الإنترنت
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      /// 2. طلب البيانات من الـ API
      final response = await apiConsumer.get(
        EndPoint.getPlaces,
        queryParameters: {
          'PageIndex': pageIndex,
          'PageSize': pageSize,
          if (search != null && search.trim().isNotEmpty)
            'Search': search.trim(),
        },
      );

      /// 3. تحويل الـ JSON إلى Model
      final data = PlacesPaginationModel.fromJson(response);

      return Right(data);
    } on DioException catch (e) {
      // التعامل مع أخطاء Dio بشكل احترافي
      return Left(ServerFailure(e.message ?? 'Server Error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
