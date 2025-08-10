import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/grocery_model.dart';

class GroceryDetailsView extends StatelessWidget {
  final GroceryModel grocery;

  const GroceryDetailsView({super.key, required this.grocery});

  @override
  Widget build(BuildContext context) {
    final LatLng groceryLocation = LatLng(grocery.lat, grocery.long);
    final greenPrimary = Color(0xFF2E7D32); // Dark green

    return Scaffold(
      appBar: AppBar(
        title: Text(
          grocery.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
          initialCenter: groceryLocation,
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
                point: groceryLocation,
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