import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/business_logic/cubit/restaurants_cubit.dart';
import 'package:frontend/constants/strings.dart';
import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/screens/map_view_screen.dart'; // Import for MapView screen
import 'package:frontend/data/repository/products_repository.dart';
import 'package:frontend/data/web_services/products_web_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import LatLng class

//TODO: add caching to restraunts.

final ProductsWebServices productsWebServices =
    ProductsWebServices(); // Initialize your web service

final ProductsRepository productsRepository = ProductsRepository(
  productsWebServices: productsWebServices,
);

class RestaurantsSearchScreen extends StatefulWidget {
  const RestaurantsSearchScreen({super.key});

  @override
  State<RestaurantsSearchScreen> createState() =>
      RestaurantsSearchScreenState();
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

class RestaurantsSearchScreenState extends State<RestaurantsSearchScreen> {
  String searchQuery = ''; // For search functionality
  late Future<List<Restaurant>> filteredRestaurants; // List of restaurants

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantsCubit>().getAllRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurants'),
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () async {
                final restaurants = await filteredRestaurants;
                final restaurantLocations =
                    restaurants
                        .map(
                          (restaurant) =>
                              LatLng(restaurant.latitude, restaurant.longitude),
                        )
                        .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MapViewScreen(
                          restaurantLocations: restaurantLocations,
                        ),
                  ),
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
                      future:
                          filteredRestaurants = filterRestaurantsByProduct(
                            state.restaurants.whereType<Restaurant>().toList(),
                            searchQuery,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
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
                                      restaurantDetailScreen,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
      ),
    );
  }
}
