class UserModel {
  String name;
  String email;
  String phoneNumber;
  String region;
  String userType;
  String joinDate;
  String image;
  String status;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.region,
    required this.userType,
    required this.joinDate,
    required this.image,
    this.status ="new"
  });

  // Factory constructor to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, String> json) {
    return UserModel(
      name: json['fullName'] ?? '',
      email: json['email'] ?? '',
      status : json["status"] ?? "",
      phoneNumber: json['phoneNumber'] ?? '',
      region: json['locationTitle'] ?? '',
      userType: json['userType'] ?? '',
      joinDate: json['Join Date'] ?? '',
      image: json["image"] ?? '',
    );
  }

  // Method to convert a UserModel to a JSON map
  Map<String, String> toJson() {
    return {
      'fullName': name,
      'email': email,
      "image":image,
      'phoneNumber': phoneNumber,
      'locationTitle': region,
      'userType': userType,
      "status":status,
      'Join Date': joinDate,
    };
  }
}
