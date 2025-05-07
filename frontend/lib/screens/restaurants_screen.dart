import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/business_logic/cubit/restaurants_cubit.dart';
import 'package:frontend/data/models/restaurant.dart';

// TODO: add search by product functionality
// TODO: add MapView in the search by product
class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => RestaurantsScreenState();
}

class RestaurantsScreenState extends State<RestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantsCubit>().getAllRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: BlocBuilder<RestaurantsCubit, RestaurantsState>(
        builder: (context, state) {
          if (state is RestaurantsInitial) {
            return const Center(
              child: Text('Load restaurants by pulling down.'),
            );
          } else if (state is RestaurantsLoaded) {
            final List<Restaurant> restaurants =
                state.restaurants
                    .where((item) => item is Restaurant)
                    .cast<Restaurant>()
                    .toList();
            return RefreshIndicator(
              onRefresh:
                  () => context.read<RestaurantsCubit>().getAllRestaurants(),
              child: ListView.separated(
                itemCount: restaurants.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return ListTile(
                    onTap: () {
                      // print('Restaurant tapped: ${restaurant.id}');
                      Navigator.pushNamed(
                        context,
                        '/restaurant_detail',
                        arguments: restaurant,
                      );
                    },
                    leading:
                        restaurant.imageUrl != null
                            ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                restaurant.imageUrl!,
                              ),
                            )
                            : const Icon(Icons.restaurant),
                    title: Text(restaurant.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurant.address),
                        if (restaurant.description != null)
                          Text(
                            restaurant.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            );
          } else if (state is RestaurantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading restaurants: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () =>
                            context
                                .read<RestaurantsCubit>()
                                .getAllRestaurants(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
