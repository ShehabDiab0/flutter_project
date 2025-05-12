import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  // Replace these with the restaurant's latitude and longitude
  final double restaurantLatitude = 37.7749; // Example: San Francisco latitude
  final double restaurantLongitude =
      -122.4194; // Example: San Francisco longitude

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(restaurantLatitude, restaurantLongitude),
          zoom: 14.0, // Adjust zoom level as needed
        ),
        markers: {
          Marker(
            markerId: const MarkerId('restaurantMarker'),
            position: LatLng(restaurantLatitude, restaurantLongitude),
            infoWindow: const InfoWindow(
              title: 'Restaurant Location',
              snippet: 'This is the restaurant.',
            ),
          ),
        },
      ),
    );
  }
}
