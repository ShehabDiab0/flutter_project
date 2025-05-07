part of 'restaurants_cubit.dart';

@immutable
abstract class RestaurantsState {}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsError extends RestaurantsState {
  final String errorMessage;
  RestaurantsError({required this.errorMessage});
}

class RestaurantsLoaded extends RestaurantsState {
  final List<dynamic> restaurants;
  RestaurantsLoaded({required this.restaurants});
}
