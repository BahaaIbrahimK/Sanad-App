// notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String uid;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.uid,
    required this.message,
    required this.timestamp,
  });

  // Convert from Map (Firestore data) to NotificationModel
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      uid: map['uid'] as String,
      message: map['message'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert NotificationModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'message': message,
      'timestamp': timestamp,
    };
  }
}