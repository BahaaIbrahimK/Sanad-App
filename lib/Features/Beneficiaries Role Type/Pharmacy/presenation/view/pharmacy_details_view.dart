import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/pharmacy_model.dart'; // Update the import to the pharmacy model

class PharmacyDetailsView extends StatelessWidget {
  final PharmacyModel pharmacy; // Change the model to PharmacyModel

  const PharmacyDetailsView({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final LatLng pharmacyLocation = LatLng(pharmacy.lat, pharmacy.long);
    final greenPrimary = Color(0xFF2E7D32); // Dark green

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pharmacy.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: greenPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: pharmacyLocation,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: pharmacyLocation,
                width: 40,
                height: 40,
                child: Container(
                  child: Icon(
                    Icons.location_pin,
                    color: greenPrimary,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}