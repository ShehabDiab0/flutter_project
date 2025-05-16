// filepath: d:\programing\flutter_project\frontend\lib\screens\map_view_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapViewScreen extends StatelessWidget {
  final List<LatLng> restaurantLocations; // List of restaurant coordinates

  const MapViewScreen({super.key, required this.restaurantLocations});

  // Function to launch Google Maps with directions
  Future<void> _launchDirections(LatLng destination) async {
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUri';
    }
  }

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
                      onTap: () {
                        // Open directions when the info window is tapped
                        _launchDirections(location);
                      },
                    ),
                  ),
                )
                .toSet(), // Convert to a Set<Marker>
      ),
    );
  }
}
