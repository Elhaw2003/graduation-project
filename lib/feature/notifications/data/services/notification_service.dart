import 'package:dio/dio.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';

class NotificationService {
  final Dio dio;

  NotificationService(this.dio);

  Future<String?> _getToken() async {
    return await SecureStorageHelper.instance.storage
        .read(key: SecureStorageHelper.accessTokenKey);
  }

  Future<Options> _authOptions() async {
    final token = await _getToken();

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> getNotifications({int page = 1, int pageSize = 20}) async {
    return dio.get(
      'https://smartguide.runasp.net/api/Notifications',
      queryParameters: {'page': page, 'pageSize': pageSize},
      options: await _authOptions(),
    );
  }

  Future<Response> getUnreadCount() async {
    return dio.get(
      'https://smartguide.runasp.net/api/Notifications/unread-count',
      options: await _authOptions(),
    );
  }

  Future<Response> markAsRead(String notificationId) async {
    return dio.patch(
      'https://smartguide.runasp.net/api/Notifications/$notificationId/read',
      options: await _authOptions(),
    );
  }

  Future<Response> markAllAsRead() async {
    return dio.patch(
      'https://smartguide.runasp.net/api/Notifications/read-all',
      options: await _authOptions(),
    );
  }

  Future<Response> deleteNotification(String notificationId) async {
    return dio.delete(
      'https://smartguide.runasp.net/api/Notifications/$notificationId',
      options: await _authOptions(),
    );
  }

  Future<Response> saveFcmToken(String token) async {
    return dio.post(
      'https://smartguide.runasp.net/api/Notifications/fcm-token',
      data: {'token': token},
      options: await _authOptions(),
    );
  }
}