import 'package:frontend/data/models/product.dart';
import 'package:frontend/data/web_services/products_web_services.dart';

class ProductsRepository {
  final ProductsWebServices productsWebServices;

  ProductsRepository({required this.productsWebServices});

  Future<List<Product>> getProductsByRestaurantId(int restaurantId) async {
    final response = await productsWebServices.fetchProducts(restaurantId);
    return (response).map((item) => Product.fromJson(item)).toList();
  }
}
