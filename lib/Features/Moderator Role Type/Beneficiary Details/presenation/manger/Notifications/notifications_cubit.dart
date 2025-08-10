import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/data/Notification_Model.dart';

import 'notifications_state.dart';


/// Cubit responsible for managing notification-related states and operations
class NotificationsCubit extends Cubit<NotificationsState> {
  final FirebaseFirestore _firestore;

  /// List to store fetched notifications
  List<NotificationModelData> notifications = [];

  /// Constructor with optional Firestore instance for dependency injection
  NotificationsCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(NotificationsInitial());


  Future<void> fetchNotifications(String uid) async {
    if (uid.isEmpty) {
      emit(NotificationsError('User ID cannot be empty'));
      return;
    }

    emit(NotificationsLoading());

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .doc(uid)
          .collection('user_notifications')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timed out'));

      notifications = querySnapshot.docs
          .map((doc) {
        try {
          return NotificationModelData.fromJson(doc.data() as Map<String, dynamic>);
        } catch (e) {
          // Log individual parsing errors but continue processing
          debugPrint('Error parsing notification ${doc.id}: $e');
          return null;
        }
      })
          .where((notification) => notification != null)
          .cast<NotificationModelData>()
          .toList();

      if (notifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(notifications));
      }
    } on FirebaseException catch (e) {
      emit(NotificationsError('Firestore error: ${e.message}'));
    }
  }

  /// Clears the current notifications list
  void clearNotifications() {
    notifications.clear();
    emit(NotificationsInitial());
  }
}

