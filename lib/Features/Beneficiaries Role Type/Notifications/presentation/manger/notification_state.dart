

import 'package:flutter/cupertino.dart';

import '../../data/Notification_Model.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}
