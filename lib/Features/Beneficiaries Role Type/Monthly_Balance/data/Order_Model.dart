import 'package:cloud_firestore/cloud_firestore.dart';

/// A model class representing an order in the application.
class OrderModel {
  final String id; // Unique identifier for the order
  final String title; // Title or name of the order
  final Timestamp date; // Date and time when the order was placed
  final double amount; // Total amount/price of the order
  final String userId; // ID of the user who placed the order

  OrderModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.userId,
  });

  /// Creates an [OrderModel] instance from a Firestore document snapshot.
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return OrderModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  /// Creates an [OrderModel] instance from a JSON map.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      title: json['order_name'] as String? ?? '',
      date: json['date'] is Timestamp
          ? json['date'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String())),
      amount: (json['price'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] as String? ?? '',
    );
  }

  /// Converts the [OrderModel] instance to a JSON map for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_name': title,
      'date': date,
      'price': amount,
      'userId': userId,
    };
  }

  /// Creates a copy of the [OrderModel] with updated values.
  OrderModel copyWith({
    String? id,
    String? title,
    Timestamp? date,
    double? amount,
    String? userId,
    String? status,
    String? description,
    List<String>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
    );
  }

  /// Returns a string representation of the [OrderModel].
  @override
  String toString() {
    return 'OrderModel(id: $id, title: $title, date: $date, amount: $amount, userId: $userId,)';
  }
}