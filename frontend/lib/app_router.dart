import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/business_logic/cubit/products_cubit.dart';
import 'package:frontend/business_logic/cubit/restaurants_cubit.dart';
import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/data/repository/products_repository.dart';
// import 'package:frontend/constants/strings.dart';
import 'package:frontend/data/repository/restaurants_repository.dart';
import 'package:frontend/data/web_services/products_web_services.dart';
import 'package:frontend/data/web_services/restaurants_web_services.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/restaurant_details_screen.dart';
// import 'package:frontend/screens/restaurant_details_screen.dart';
import 'package:frontend/screens/restaurants_screen.dart';
import 'package:frontend/screens/login_screen.dart';

// TODO: Replace all hardcoded strings with constants
class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/restaurants':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => RestaurantsCubit(
                      restaurantsRepository: RestaurantsRepository(
                        restaurantsWebServices: RestaurantsWebServices(),
                      ),
                    ),
                child: const RestaurantsScreen(),
              ),
        );

      case '/restaurant_detail':
        final restaurant = settings.arguments as Restaurant;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => ProductCubit(
                      productsRepository: ProductsRepository(
                        productsWebServices: ProductsWebServices(),
                      ),
                    ),
                child: RestaurantDetailsScreen(restaurant: restaurant),
              ),
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text("Page Not Found"))),
        );
    }
  }
}
