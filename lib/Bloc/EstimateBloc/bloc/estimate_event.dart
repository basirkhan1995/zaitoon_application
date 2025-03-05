part of 'estimate_bloc.dart';

sealed class EstimateEvent extends Equatable {
  const EstimateEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends EstimateEvent {
  final List<InvoiceItems> items;
  const AddItemEvent(this.items);
}

class UpdateTaxEvent extends EstimateEvent {
  final double tax;
  const UpdateTaxEvent(this.tax);
}

class UpdateDiscountEvent extends EstimateEvent {
  final double discount;
  const UpdateDiscountEvent(this.discount);
}

class RemoveItemEvent extends EstimateEvent {
  final int index;
  const RemoveItemEvent(this.index);
}

class LoadItemsEvent extends EstimateEvent {}

class ResetItemsEvent extends EstimateEvent {}

class UpdateItemEvent extends EstimateEvent {
  final int index;
  final InvoiceItems updatedInvoice;

  const UpdateItemEvent(this.index, this.updatedInvoice);
}
