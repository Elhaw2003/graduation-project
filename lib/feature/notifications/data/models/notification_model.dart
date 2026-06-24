import 'notification_model.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? referenceId;
  final String? referenceType;
  final DateTime createdAtUtc;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAtUtc,
    this.referenceId,
    this.referenceType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      referenceId: json['referenceId'],
      referenceType: json['referenceType'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
    );
  }
}

class NotificationsResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int totalCount;

  NotificationsResponse({
    required this.notifications,
    required this.unreadCount,
    required this.totalCount,
  });

  factory NotificationsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationsResponse(
      notifications:
          (json['notifications'] as List)
              .map(
                (e) =>
                    NotificationModel.fromJson(e),
              )
              .toList(),
      unreadCount: json['unreadCount'],
      totalCount: json['totalCount'],
    );
  }
}