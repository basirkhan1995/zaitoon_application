part of 'inventory_cubit.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();
}

final class InventoryInitial extends InventoryState {
  @override
  List<Object> get props => [];
}

final class InventoryErrorState extends InventoryState{
  final String error;
  const InventoryErrorState(this.error);
  @override
  List<Object> get props => [error];
}

final class LoadedInventoryState extends InventoryState{
  final List<InventoryModel> inventories;
  const LoadedInventoryState(this.inventories);
  @override
  List<Object> get props => [inventories];
}
