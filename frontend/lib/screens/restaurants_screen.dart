import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/business_logic/cubit/restaurants_cubit.dart';
import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/screens/map_view_screen.dart'; // Import for MapView screen
import 'package:frontend/data/repository/products_repository.dart';
import 'package:frontend/data/web_services/products_web_services.dart';
import 'package:frontend/data/models/product.dart';
// TODO: add search by product functionality
// TODO: add MapView in the search by product

final ProductsWebServices productsWebServices =
    ProductsWebServices(); // Initialize your web service

final ProductsRepository productsRepository = ProductsRepository(
  productsWebServices: productsWebServices,
);

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => RestaurantsScreenState();
}

Future<List<Restaurant>> filterRestaurantsByProduct(
  List<Restaurant> restaurants,
  String searchQuery,
) async {
  final filteredRestaurants = <Restaurant>[];

  for (final restaurant in restaurants) {
    // Fetch products for the restaurant using its ID
    final products = await productsRepository.getProductsByRestaurantId(
      restaurant.id,
    );

    // Check if any product matches the search query
    final hasMatchingProduct = products.any(
      (product) =>
          product.name.toLowerCase().contains(searchQuery.toLowerCase()),
    );

    if (hasMatchingProduct) {
      filteredRestaurants.add(restaurant);
    }
  }

  return filteredRestaurants;
}

class RestaurantsScreenState extends State<RestaurantsScreen> {
  String searchQuery = ''; // For search functionality

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
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapViewScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<RestaurantsCubit, RestaurantsState>(
              builder: (context, state) {
                if (state is RestaurantsInitial) {
                  return const Center(
                    child: Text('Load restaurants by pulling down.'),
                  );
                } else if (state is RestaurantsLoaded) {
                  // Use FutureBuilder to handle the Future<List<Restaurant>>
                  return FutureBuilder<List<Restaurant>>(
                    future: filterRestaurantsByProduct(
                      state.restaurants.whereType<Restaurant>().toList(),
                      searchQuery,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No restaurants found.'),
                        );
                      } else {
                        final restaurants = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh:
                              () =>
                                  context
                                      .read<RestaurantsCubit>()
                                      .getAllRestaurants(),
                          child: ListView.separated(
                            itemCount: restaurants.length,
                            separatorBuilder:
                                (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final restaurant = restaurants[index];
                              return ListTile(
                                onTap: () {
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
                      }
                    },
                  );
                } else if (state is RestaurantsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading restaurants: ${state.errorMessage}',
                        ),
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
          ),
        ],
      ),
    );
  }
}
