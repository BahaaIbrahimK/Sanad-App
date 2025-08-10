class GroceryModel {
  final String title; // Title of the grocery store
  final String locationTitle; // Title of the location (e.g., "أسواق التميمي")
  final double lat; // Latitude of the location
  final double long; // Longitude of the location

  GroceryModel({
    required this.title,
    required this.locationTitle,
    required this.lat,
    required this.long,
  });

  // Factory method to create a GroceryModel from a JSON object
  factory GroceryModel.fromJson(Map<String, dynamic> json) {
    return GroceryModel(
      title: json['title'] ?? '',
      locationTitle: json['locationTitle'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
    );
  }

  // Convert GroceryModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'locationTitle': locationTitle,
      'lat': lat,
      'long': long,
    };
  }
}