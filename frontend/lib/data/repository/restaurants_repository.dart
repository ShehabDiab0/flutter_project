import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/data/web_services/restaurants_web_services.dart';

class RestaurantsRepository {
  final RestaurantsWebServices restaurantsWebServices;

  RestaurantsRepository({required this.restaurantsWebServices});

  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final restaurants = await restaurantsWebServices.getAllRestaurants();
      return restaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
