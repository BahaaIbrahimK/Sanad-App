// States
import '../../../data/Notification_Model.dart';

abstract class NotificationsState {
  const NotificationsState();
}

/// Initial state of the notifications
class NotificationsInitial extends NotificationsState {}

/// State when notifications are being loaded
class NotificationsLoading extends NotificationsState {}

/// State when notifications are successfully loaded
class NotificationsLoaded extends NotificationsState {
  final List<NotificationModelData> notifications;

  const NotificationsLoaded(this.notifications);
}

/// State when no notifications are found
class NotificationsEmpty extends NotificationsState {}

/// State when an error occurs
class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);
}