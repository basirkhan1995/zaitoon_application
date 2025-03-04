part of 'invoice_cubit.dart';

sealed class InvoiceState extends Equatable {
  const InvoiceState();
}

final class InvoiceInitial extends InvoiceState {
  @override
  List<Object> get props => [];
}

final class LoadedInvoiceItemsState2 extends InvoiceState{
  final List<InvoiceItems> items;
  const LoadedInvoiceItemsState2(this.items);
  @override
  List<Object> get props => [items];
}

class LoadedInvoiceItemsState extends InvoiceState {
  final List<InvoiceItems> items;
  final String? currency;
  final String? vat;
  final String? discount;

  const LoadedInvoiceItemsState(
      this.items, {
        this.currency,
        this.vat,
        this.discount,
      });

  @override
  List<Object?> get props => [items, currency, vat, discount];

  // Define the copyWith method
  LoadedInvoiceItemsState copyWith({
    List<InvoiceItems>? items,
    String? currency,
    String? vat,
    String? discount,
  }) {
    return LoadedInvoiceItemsState(
      items ?? this.items,
      currency: currency ?? this.currency,
      vat: vat ?? this.vat,
      discount: discount ?? this.discount,
    );
  }
}

final class ErrorInvoiceState extends InvoiceState{
  final String error;
  const ErrorInvoiceState(this.error);
  @override
  List<Object> get props => [error];
}
