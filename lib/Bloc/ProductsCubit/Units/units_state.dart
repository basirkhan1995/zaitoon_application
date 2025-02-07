part of 'units_cubit.dart';

sealed class UnitsState extends Equatable {
  const UnitsState();
}

final class UnitsInitial extends UnitsState {
  @override
  List<Object> get props => [];
}

final class ProductUnitsErrorState extends UnitsState{
  final String error;
  const ProductUnitsErrorState(this.error);
  @override
  List<Object> get props => [error];
}

final class LoadedProductsUnitsState extends UnitsState{
  final List<ProductsUnitModel> units;
  const LoadedProductsUnitsState(this.units);
  @override
  List<Object> get props => [units];
}