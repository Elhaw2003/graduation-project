abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
