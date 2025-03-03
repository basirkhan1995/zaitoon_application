import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/InvoiceCubit/cubit/invoice_state.dart';
import 'package:zaitoon_invoice/Json/invoice_model.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit()
      : super(InvoiceState(
          invoiceDetails: InvoiceDetails(
              clientName: '',
              invoiceNumber: '',
              subtotal: 0,
              vat: 0,
              discount: 0,
              total: 0),
          invoiceItems: [],
        ));

  void addInvoiceItem() {
    final newItem = InvoiceItems(rowNumber: state.invoiceItems.length + 1);

    // Explicitly type the list as List<InvoiceItems> to ensure the correct type
    final updatedItems = List<InvoiceItems>.from(state.invoiceItems)
      ..add(newItem);

    emit(state.copyWith(invoiceItems: updatedItems));
    updateInvoiceDetails();
  }

  void removeInvoiceItem(int rowNumber) {
    final updatedItems = state.invoiceItems
        .where((item) => item.rowNumber != rowNumber)
        .toList();

    emit(state.copyWith(invoiceItems: updatedItems));
    updateInvoiceDetails();
  }

  void updateInvoiceItem(int rowNumber,
      {String? itemName, int? quantity, double? amount}) {
    final updatedItems = state.invoiceItems.map((item) {
      if (item.rowNumber == rowNumber) {
        return item.copyWith(
          itemName: itemName ?? item.itemName,
          quantity: quantity ?? item.quantity,
          amount: amount ?? item.amount,
        );
      }
      return item;
    }).toList();

    emit(state.copyWith(invoiceItems: updatedItems));
    updateInvoiceDetails();
  }

  void updateInvoiceDetails() {
    // Use 0.0 as the initial value to handle doubles in the fold method
    final subtotal = state.invoiceItems
        .fold(0.0, (sum, item) => sum + (item.amount * item.quantity));

    final discount = state.invoiceDetails.discount;
    final vat = state.invoiceDetails.vat;

    final total =
        subtotal + (subtotal * vat / 100) - (subtotal * discount / 100);

    final updatedDetails = state.invoiceDetails.copyWith(
      subtotal: subtotal,
      total: total,
    );

    emit(state.copyWith(invoiceDetails: updatedDetails));
  }
}
