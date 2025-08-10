// models/transaction.dart
class TransactionModel {
  final String id;
  final double amount;
  final String type;
  final String userId;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.userId,
  });

  // Convert Firestore document to TransactionModel object
  factory TransactionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TransactionModel(
      id: id,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] as String,
      userId: data['user_id'] as String,
    );
  }

  // Convert TransactionModel object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'type': type,
      'user_id': userId,
    };
  }
}