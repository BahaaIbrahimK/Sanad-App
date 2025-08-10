class NotificationModelData {
  final String message;
  final DateTime timestamp;
  final String uid;

  NotificationModelData({
    required this.message,
    required this.timestamp,
    required this.uid,
  });

  // Factory constructor to create a NotificationModel from JSON
  factory NotificationModelData.fromJson(Map<String, dynamic> json) {
    return NotificationModelData(
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      uid: json['uid'] as String,
    );
  }

  // Method to convert a NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to string
      'uid': uid,
    };
  }
}