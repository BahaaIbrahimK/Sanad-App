import 'dart:io';

class StoreModel {
  final String? id;
  final String storeName;
  final String storeLocation;
  final String storeType;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  StoreModel({
    this.id,
    required this.storeName,
    required this.storeLocation,
    required this.storeType,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': storeName,
      'locationTitle': storeLocation,
      'storeType': storeType,
      'imageUrl': imageUrl,
      'lat': latitude,
      'long': longitude,
    };
  }

  factory StoreModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return StoreModel(
      id: id,
      storeName: json['title'] ?? '',
      storeLocation: json['locationTitle'] ?? '',
      storeType: json['storeType'] ?? '',
      imageUrl: json['imageUrl'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
