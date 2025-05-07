import 'package:bloc/bloc.dart';
import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/data/repository/restaurants_repository.dart';
import 'package:meta/meta.dart';

part 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  final RestaurantsRepository restaurantsRepository;

  RestaurantsCubit({required this.restaurantsRepository})
    : super(RestaurantsInitial());

  late List<Restaurant> restaurants;

  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final fetchedRestaurants =
          await restaurantsRepository.getAllRestaurants();

      restaurants = fetchedRestaurants;
      emit(RestaurantsLoaded(restaurants: fetchedRestaurants));
      return fetchedRestaurants;
    } catch (e) {
      emit(RestaurantsError(errorMessage: e.toString()));
      return [];
    }
  }
}
