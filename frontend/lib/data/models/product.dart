class Product {
  final int id;
  final int restaurantId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      restaurantId: json['restaurant'], // Typically the foreign key value
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
