class PharmacyModel {
  final String name; // Name of the pharmacy
  final String locationTitle; // Title of the location (e.g., "صيدلية النهدي")
  final double lat; // Latitude of the location
  final double long; // Longitude of the location

  PharmacyModel({
    required this.name,
    required this.locationTitle,
    required this.lat,
    required this.long,

  });

  // Factory method to create a PharmacyModel from a JSON object
  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      name: json['title'] ?? '',
      locationTitle: json['locationTitle'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
    );
  }

  // Convert PharmacyModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locationTitle': locationTitle,
      'lat': lat,
      'long': long,
    };
  }
}