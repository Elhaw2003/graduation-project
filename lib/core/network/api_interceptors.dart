import 'package:dio/dio.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';

    final token = await SecureStorageHelper.instance.getAccessToken();
    if (token != null) {
      options.headers["Authorization"] = '${ApiKey.tokenPrefix} $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. لو الخطأ 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorageHelper.instance.getRefreshToken();
      final accessToken = await SecureStorageHelper.instance.getAccessToken();

      if (refreshToken != null && accessToken != null) {
        try {
          // 2. استخدم Dio جديد تماماً لعملية الـ Refresh عشان تتجنب الـ Loop
          final dio = Dio();
          final response = await dio.post(
            '${EndPoint.baseUrl}${EndPoint.refreshToken}',
            data: {
              SecureStorageHelper.accessTokenKey: accessToken,
              SecureStorageHelper.refreshTokenKey: refreshToken,
            },
          );

          // 3. استخراج البيانات الجديدة
          final newToken = response.data["token"];
          final newRefreshToken = response.data["refreshToken"];
          final newExpiresAt = response.data["expiresOn"];
          final newRefreshTokenExpiresOn =
              response.data["refreshTokenExpiresOn"];

          // 4. حفظ البيانات الجديدة
          await SecureStorageHelper.instance.saveTokens(
            accessToken: newToken,
            refreshToken: newRefreshToken,
            expiresAt: newExpiresAt,
            refreshTokenExpiresOn: newRefreshTokenExpiresOn,
          );

          // 5. تعديل الـ Header بتاع الـ Request القديم اللي فشل
          err.requestOptions.headers['Authorization'] =
              '${ApiKey.tokenPrefix} $newToken';

          // 6. إعادة إرسال الـ Request القديم (Retry)
          // بنستخدم Dio() جديد هنا برضه أو الـ Instance الأساسية بس نبعت الـ RequestOptions
          final retryDio = Dio();
          final retryResponse = await retryDio.fetch(err.requestOptions);

          // 7. حل المشكلة ورجع الـ Response الناجح للـ App وكأن مفيش حاجة حصلت
          return handler.resolve(retryResponse);
        } catch (e) {
          // لو الـ Refresh نفسه فشل (مثلاً الـ Refresh token انتهى)
          // هنا لازم تعمل Logout لليوزر وتوديه لشاشة الـ Login
          // ممكن تستخدم Event Bus أو أي طريقة تانية لتنبيه الـ UI
          return handler.next(err);
        }
      }
    }
    // لو مش 401، كمل الـ Error عادي
    return handler.next(err);
  }
}
