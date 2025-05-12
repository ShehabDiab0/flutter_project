import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({Key? key}) : super(key: key);

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
