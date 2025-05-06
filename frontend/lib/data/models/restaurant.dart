class Restaurant {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final String? imageUrl; // Assuming this is a URL to the image
  final DateTime createdAt;

  Restaurant({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
