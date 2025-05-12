import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text(
          'Map functionality will be implemented here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
