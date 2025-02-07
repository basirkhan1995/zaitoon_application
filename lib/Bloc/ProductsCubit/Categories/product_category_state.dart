part of 'product_category_cubit.dart';

sealed class ProductCategoryState extends Equatable {
  const ProductCategoryState();
}

final class ProductCategoryInitial extends ProductCategoryState {
  @override
  List<Object> get props => [];
}

final class ProductCategoryErrorState extends ProductCategoryState{
  final String error;
  const ProductCategoryErrorState(this.error);
  @override
  List<Object> get props => [error];
}

final class LoadedProductsCategoryState extends ProductCategoryState{
  final List<ProductsCategoryModel> categories;
  const LoadedProductsCategoryState(this.categories);
  @override
  List<Object> get props => [];
}
