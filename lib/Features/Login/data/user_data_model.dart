class UserDataModel {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final String userType;
  final String locationTitle;
  final String status;

  UserDataModel({
    this.status = "new",
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    required this.locationTitle,
  });

  // Factory constructor from JSON
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      userType: json['userType'] as String? ?? 'regular',
      locationTitle: json['locationTitle'] as String? ?? '',
      status: json['status'] as String? ?? '',

    );
  }

  // Convert to JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'locationTitle': locationTitle,
      'status': status,

    };
  }
}
