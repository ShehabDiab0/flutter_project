import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/product.dart';
import 'package:frontend/data/repository/products_repository.dart';

part 'products_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductsRepository productsRepository;

  ProductCubit({required this.productsRepository}) : super(ProductsInitial());

  Future<void> fetchProducts(int restaurantId) async {
    emit(ProductsLoading());
    try {
      final products = await productsRepository.getProductsByRestaurantId(
        restaurantId,
      );
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
