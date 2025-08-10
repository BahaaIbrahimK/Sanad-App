import 'package:cloud_firestore/cloud_firestore.dart';

class CreditCard {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final DateTime? lastUpdated;

  CreditCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.lastUpdated,
  });

  // From JSON (Firestore document to object)
  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json['card_number'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
      lastUpdated: json['last_updated'] != null
          ? (json['last_updated'] as Timestamp).toDate()
          : null,
    );
  }

  // To JSON (object to Firestore document)
  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'last_updated': FieldValue.serverTimestamp(),
    };
  }
}