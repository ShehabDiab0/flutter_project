import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app_router.dart';
import 'package:frontend/business_logic/cubit/login_cubit.dart';
import 'package:frontend/business_logic/cubit/register_cubit.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/data/web_services/auth_web_services.dart';
import 'package:frontend/data/web_services/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is fully initialized

  final authRepo = AuthRepository(AuthWebServices());
  final loginCubit = LoginCubit(authRepo);
  final tokenManager = TokenManager(); // Initialize TokenManager

  // Check token state using TokenManager
  String initialRoute = '/login'; // Default to login page
  final validAccessToken = await tokenManager.getValidAccessToken();
  if (validAccessToken != null) {
    initialRoute = '/restaurants'; // Navigate to restaurants if logged in
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => loginCubit),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(authRepo)),
      ],
      child: RestaurantApp(appRouter: AppRouter(), initialRoute: initialRoute),
    ),
  );
}

class RestaurantApp extends StatelessWidget {
  final AppRouter appRouter;
  final String initialRoute;

  const RestaurantApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute, // Dynamically set the initial route
    );
  }
}
