part of 'invoice_cubit.dart';

sealed class InvoiceState extends Equatable {
  const InvoiceState();
}

final class InvoiceInitial extends InvoiceState {
  @override
  List<Object> get props => [];
}
