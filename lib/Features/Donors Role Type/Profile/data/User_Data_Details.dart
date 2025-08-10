import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  final String fullName;
  final String locationTitle;
  final String phoneNumber;
  final String status;
  final String uid;
  final String userType;

  UserDetailsModel({
    required this.fullName,
    required this.locationTitle,
    required this.phoneNumber,
    required this.status,
    required this.uid,
    required this.userType,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      fullName: json['fullName'] as String? ?? '',
      locationTitle: json['locationTitle'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      status: json['status'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      userType: json['userType'] as String? ?? '',
    );
  }

  // Convert UserDetailsModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'locationTitle': locationTitle,
      'phoneNumber': phoneNumber,
      'status': status,
      'uid': uid,
      'userType': userType,
    };
  }
}