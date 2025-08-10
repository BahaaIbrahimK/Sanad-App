// notifications_cubit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/Features/Beneficiaries%20Role%20Type/Notifications/presentation/manger/notification_state.dart';
import '../../data/Notification_Model.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationsCubit() : super(NotificationsInitial());

  Future<void> fetchNotifications(String uid) async {
    try {
      emit(NotificationsLoading());

      final notificationsRef = _firestore
          .collection('notifications')
          .doc(uid)
          .collection('user_notifications');

      final snapshot = await notificationsRef.get();

      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data()))
          .toList();

      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      final notificationsRef = _firestore
          .collection('notifications')
          .doc(notification.uid)
          .collection('user_notifications');

      await notificationsRef.add(notification.toMap());
      // After adding, fetch updated list
      await fetchNotifications(notification.uid);
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
