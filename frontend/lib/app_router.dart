import 'package:flutter/material.dart';
import 'package:frontend/constants/strings.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/restaurant_details_screen.dart';
import 'package:frontend/screens/restaurants_screen.dart';
import 'package:frontend/screens/login_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case restaurantsScreen:
        return MaterialPageRoute(builder: (_) => const RestaurantScreen());

      case restaurantDetailScreen:
        return MaterialPageRoute(
          builder: (_) => const RestaurantDetailsScreen(),
        );

      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case 'register':
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
