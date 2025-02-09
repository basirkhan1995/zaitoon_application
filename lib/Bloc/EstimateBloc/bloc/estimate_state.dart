part of 'estimate_bloc.dart';

sealed class EstimateState extends Equatable {
  const EstimateState();

  @override
  List<Object> get props => [];
}

final class EstimateInitial extends EstimateState {}

class InvoiceItemsLoadedState extends EstimateState {
  final List<EstimateItemsModel> items;
  const InvoiceItemsLoadedState(this.items);
}

class InvoiceItemError extends EstimateState {
  final String error;
  const InvoiceItemError(this.error);
}
