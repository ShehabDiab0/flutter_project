import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatelessWidget {
  final List<LatLng> restaurantLocations; // List of restaurant coordinates

  const MapViewScreen({super.key, required this.restaurantLocations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              restaurantLocations.isNotEmpty
                  ? restaurantLocations[0] // Focus on the first restaurant
                  : const LatLng(
                    0,
                    0,
                  ), // Default to (0, 0) if the list is empty
          zoom: 14.0, // Adjust zoom level as needed
        ),
        markers:
            restaurantLocations
                .map(
                  (location) => Marker(
                    markerId: MarkerId(location.toString()), // Unique marker ID
                    position: location,
                    infoWindow: InfoWindow(
                      title: 'Restaurant Location',
                      snippet:
                          'Lat: ${location.latitude}, Lng: ${location.longitude}',
                    ),
                  ),
                )
                .toSet(), // Convert to a Set<Marker>
      ),
    );
  }
}
