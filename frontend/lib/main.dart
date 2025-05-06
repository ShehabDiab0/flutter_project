import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app_router.dart';
import 'package:frontend/business_logic/cubit/login_cubit.dart';
import 'package:frontend/business_logic/cubit/register_cubit.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/data/web_services/auth_web_services.dart';

void main() {
  final authRepo = AuthRepository(AuthWebServices());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(authRepo)),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(authRepo)),
      ],
      child: RestaurantApp(appRouter: AppRouter()),
    ),
  );
}

class RestaurantApp extends StatelessWidget {
  final AppRouter appRouter;

  const RestaurantApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: '/login',
    );
  }
}
