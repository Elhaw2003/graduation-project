import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart'; // لو بتستخدم فحص الإنترنت
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datail_repo.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';

class GetPlaceDetailRepoImple implements GetPlaceDatailRepo {
  final ApiConsumer apiConsumer;

  GetPlaceDetailRepoImple({required this.apiConsumer});

  @override
  Future<Either<Failure, PlaceModel>> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      // 1. فحص الاتصال بالإنترنت (اختياري بس يُفضل بناءً على كودك السابق)
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // 2. طلب البيانات من الـ API
      // بافتراض إن الـ Endpoint هو /api/places/{id}
      final response = await apiConsumer.get(
        EndPoint.getPlaceDetails(id: placeId),
      );

      // 3. تحويل الـ JSON لـ PlaceModel
      final placeDetail = PlaceModel.fromJson(response);

      return Right(placeDetail);
    } on ServerException catch (e) {
      // أخطاء السيرفر (زي 404 أو 500) لو الـ ApiConsumer بيرميها
      return Left(ServerFailure(e.errModel.errorMessage));
    } on DioException catch (e) {
      // أخطاء شبكة أو تايم أوت
      return Left(ServerFailure(e.message ?? 'Server Error occurred'));
    } catch (e) {
      // أي خطأ تاني غير متوقع (زي خطأ في الـ Parsing)
      return Left(ServerFailure(e.toString()));
    }
  }
}
