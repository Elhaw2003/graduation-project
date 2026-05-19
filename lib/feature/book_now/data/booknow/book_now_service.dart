import 'package:dio/dio.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_details_model.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';

class BookNowService {
  final Dio dio;

  BookNowService(this.dio);

  Future<List<TourModel>> getGuideTours({required String guideId}) async {
    final token = await SecureStorageHelper.instance.getAccessToken();

    final response = await dio.get(
      'https://smartguide.runasp.net/api/Tours/guide/$guideId',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List data = response.data;

    return data.map((e) => TourModel.fromJson(e)).toList();
  }

Future<TourDetailsModel> getTourDetails({
  required String tourId,
}) async {

  final token =
      await SecureStorageHelper.instance
          .getAccessToken();

  final response = await dio.get(
    'https://smartguide.runasp.net/api/Tours/$tourId',

    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );

  return TourDetailsModel.fromJson(
    response.data,
  );
}

}
