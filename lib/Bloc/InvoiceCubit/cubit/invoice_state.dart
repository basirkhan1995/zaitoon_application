import 'package:zaitoon_invoice/Json/invoice_model.dart';

// Cubit State
class InvoiceState {
  final InvoiceDetails invoiceDetails;
  final List<InvoiceItems> invoiceItems;

  InvoiceState({required this.invoiceDetails, required this.invoiceItems});

  InvoiceState copyWith({
    InvoiceDetails? invoiceDetails,
    List<InvoiceItems>? invoiceItems,
  }) {
    return InvoiceState(
      invoiceDetails: invoiceDetails ?? this.invoiceDetails,
      invoiceItems: invoiceItems ?? this.invoiceItems,
    );
  }
}
