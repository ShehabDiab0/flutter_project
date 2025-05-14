import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/business_logic/cubit/products_cubit.dart';
import 'package:frontend/data/repository/products_repository.dart';
import 'package:frontend/data/web_services/products_web_services.dart';
import 'package:frontend/data/models/restaurant.dart';
import 'package:frontend/data/models/product.dart';
import 'package:frontend/screens/map_view_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProductCubit(
            productsRepository: ProductsRepository(
              productsWebServices: ProductsWebServices(),
            ),
          )..fetchProducts(restaurant.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(restaurant.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MapViewScreen(
                          restaurantLocations: [
                            LatLng(restaurant.latitude, restaurant.longitude),
                          ],
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoaded) {
              return RefreshIndicator(
                onRefresh:
                    () => context.read<ProductCubit>().fetchProducts(
                      restaurant.id,
                    ),
                child: ListView.separated(
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ListTile(
                      onTap: () => _showProductDetail(context, product),
                      leading:
                          product.imageUrl != null
                              ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  product.imageUrl!,
                                ),
                              )
                              : const Icon(Icons.fastfood),
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${product.price.toStringAsFixed(2)}'),
                          if (product.category != null)
                            Text('Category: ${product.category!}'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    );
                  },
                ),
              );
            } else if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading products: ${state.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<ProductCubit>().fetchProducts(
                            restaurant.id,
                          ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(product.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null) Image.network(product.imageUrl!),
                const SizedBox(height: 8),
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                if (product.description.isNotEmpty)
                  Text('Description: ${product.description}'),
                if (product.category != null)
                  Text('Category: ${product.category!}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
