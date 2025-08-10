// User Profile data model
class UserProfile {
  final dynamic id;
  final dynamic name;
  final dynamic address;
  final dynamic phone;
  dynamic income;
  final dynamic familySize;
  dynamic monthlyAmount;
  final dynamic housingDescription;
  final List<Map<String, dynamic>> documents;
  String? status;

  UserProfile({
    required this.id,
    required this.name,
    required this.monthlyAmount,
    required this.address,
    required this.phone,
    required this.income,
    required this.familySize,
    required this.housingDescription,
    this.documents = const [],
    this.status = "new",
  });

  // Create a copy of the current profile with some fields updated
  UserProfile copyWith({
    String? name,
    String? address,
    String? phone,
    String? income,
    String? familySize,
    String? housingDescription,
    List<Map<String, dynamic>>? documents,
    String? status,
  }) {
    return UserProfile(
      id: this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      income: income ?? this.income,
      familySize: familySize ?? this.familySize,
      housingDescription: housingDescription ?? this.housingDescription,
      documents: documents ?? this.documents,
      monthlyAmount: this.monthlyAmount,
    );
  }

  // Convert Firestore map to UserProfile object
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['uid'] ?? '',
      monthlyAmount: map['monthlyAmount'] ?? '',
      name: map['fullName'] ?? '',
      address: map['locationTitle'] ?? '',
      phone: map['phoneNumber'] ?? '',
      income: map['income'] ?? '',
      familySize: map['familySize'] ?? '',
      status: map["status"] ?? '',
      housingDescription: map['housingDescription'] ?? '',
      documents: List<Map<String, dynamic>>.from(map['documents'] ?? []),
    );
  }

  // Convert UserProfile object to a Firestore map
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'fullName': name,
      'locationTitle': address,
      'phoneNumber': phone,
      'income': income,
      'familySize': familySize,
      "monthlyAmount": monthlyAmount,
      'status': status,
      'housingDescription': housingDescription,
      'documents': documents,
    };
  }
}
