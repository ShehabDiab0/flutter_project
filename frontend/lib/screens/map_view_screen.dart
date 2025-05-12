import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatelessWidget {
  final double restaurantLatitude;
  final double restaurantLongitude;

  const MapViewScreen({
    super.key,
    required this.restaurantLatitude,
    required this.restaurantLongitude,
  });

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
