import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/notifications/data/logic/notification_state.dart';
import 'package:smart_guide/feature/notifications/data/models/notification_model.dart';
import 'package:smart_guide/feature/notifications/data/services/notification_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.service) : super(NotificationInitial());

  final NotificationService service;

  List<NotificationModel> notifications = [];

  int unreadCount = 0;

  int totalCount = 0;

  Future<void> getNotifications() async {
    try {
      emit(NotificationLoading());

      final response = await service.getNotifications();

      final result = NotificationsResponse.fromJson(response.data);

      notifications = result.notifications;

      unreadCount = result.unreadCount;

      totalCount = result.totalCount;

      emit(NotificationLoaded());
      print(response.data);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> getUnreadCount() async {
    try {
      final response = await service.getUnreadCount();

      unreadCount = response.data;

      emit(NotificationLoaded());
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    try {
      await service.markAsRead(id);

      final index = notifications.indexWhere((e) => e.id == id);

      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          type: notifications[index].type,
          isRead: true,
          createdAtUtc: notifications[index].createdAtUtc,
          referenceId: notifications[index].referenceId,
          referenceType: notifications[index].referenceType,
        );

        unreadCount--;
      }

      emit(NotificationLoaded());
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await service.markAllAsRead();

      notifications = notifications
          .map(
            (e) => NotificationModel(
              id: e.id,
              title: e.title,
              message: e.message,
              type: e.type,
              isRead: true,
              createdAtUtc: e.createdAtUtc,
              referenceId: e.referenceId,
              referenceType: e.referenceType,
            ),
          )
          .toList();

      unreadCount = 0;

      emit(NotificationLoaded());
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      await service.deleteNotification(id);

      notifications.removeWhere((e) => e.id == id);

      emit(NotificationLoaded());
    } catch (_) {}
  }

  void addNotification(NotificationModel notification) {
    notifications.insert(0, notification);

    unreadCount++;

    emit(NotificationLoaded());
  }
}
