part of 'estimate_bloc.dart';

sealed class EstimateState extends Equatable {
  const EstimateState();

  @override
  List<Object> get props => [];
}

final class EstimateInitial extends EstimateState {}

class EstimateItemsLoadedState extends EstimateState {
  final List<EstimateItemsModel> items;
  const EstimateItemsLoadedState(this.items);
  @override
  List<Object> get props => [items];
}

class EstimateItemError extends EstimateState {
  final String error;
  const EstimateItemError(this.error);
  @override
  List<Object> get props => [error];
}
