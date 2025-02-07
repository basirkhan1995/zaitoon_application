part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();
}

final class ProductsInitial extends ProductsState {
  @override
  List<Object> get props => [];
}

final class ProductsErrorState extends ProductsState{
  final String error;
  const ProductsErrorState (this.error);
  @override
  List<Object> get props => [error];
}

final class LoadedProductsState extends ProductsState{
  final List<ProductsModel> products;
  const LoadedProductsState(this.products);
  @override
  List<Object> get props => [products];
}
