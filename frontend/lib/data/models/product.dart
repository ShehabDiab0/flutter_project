import 'package:frontend/data/models/restaurant.dart';

class Product {
  final int id;
  final Restaurant restaurant;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.restaurant,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      restaurant: Restaurant.fromJson(json['restaurant']),
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price']) ?? 0.0,
      imageUrl: json['image_url'],
      category: json['category'] ?? 'Uncategorized',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
