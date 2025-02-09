part of 'estimate_cubit.dart';

sealed class EstimateState extends Equatable {
  const EstimateState();
}

final class EstimateInitial extends EstimateState {
  @override
  List<Object> get props => [];
}

final class InvoiceItemTableLoadedState extends EstimateState{
  final List<EstimateItemsModel> estimateItems;
  const InvoiceItemTableLoadedState(this.estimateItems);
  @override
  List<Object> get props => [estimateItems];
}

final class FailureInvoiceState extends EstimateState{
  final String error;
  const FailureInvoiceState(this.error);
  @override
  List<Object> get props => [error];
}

