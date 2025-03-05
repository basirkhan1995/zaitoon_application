import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import '../../../../Json/invoice_model.dart';

class TotalWidget extends StatefulWidget {
  final List<InvoiceItems> invoiceItems;
  final InvoiceDetails info;
  final String vat;
  final String discount;

  const TotalWidget({
    super.key,
    required this.invoiceItems,
    required this.info,
    required this.vat,
    required this.discount,
  });

  @override
  TotalWidgetState createState() => TotalWidgetState();
}

class TotalWidgetState extends State<TotalWidget> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    double calculateSubtotal() {
      double subtotal = 0.0;
      for (var item in widget.invoiceItems) {
        subtotal += item.quantity * item.amount;
      }
      return subtotal;
    }

    double calculateTotalVat() {
      double totalVat = 0.0;
      double subtotal = calculateSubtotal();
      if (widget.vat.isNotEmpty) {
        totalVat += subtotal * (double.parse(widget.vat)) / 100;
      }
      return totalVat;
    }

    double calculateDiscount() {
      double totalDiscount = 0.0;
      double subtotal = calculateSubtotal();

      if (widget.discount.isNotEmpty) {
        totalDiscount += (subtotal * (double.parse(widget.discount))) / 100;
      }

      return totalDiscount;
    }

    double calculateTotal() {
      double subtotal = calculateSubtotal();
      double totalVat = calculateTotalVat();
      double totalDiscount = calculateDiscount();
      return subtotal + totalVat - totalDiscount;
    }

    final subtotal = calculateSubtotal();
    final totalVat = calculateTotalVat();
    final totalDiscount = calculateDiscount();
    final total = calculateTotal();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textRich(
                  title: locale.subtotal,
                  value: subtotal,
                  end: widget.info.currency,
                  color: Colors.cyan),
              textRich(
                  title: locale.tax,
                  value: totalVat,
                  end: widget.info.currency,
                  color: Colors.cyan),
              textRich(
                  title: locale.discount,
                  value: totalDiscount,
                  end: widget.info.currency,
                  color: Colors.cyan),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withValues(alpha: .2),
                          spreadRadius: 1)
                    ]),
                child: Text(
                  "${locale.total}: ${total.toStringAsFixed(2)} ${widget.info.currency}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget textRich(
      {required title, required value, required end, Color? color}) {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${value.toStringAsFixed(2)} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color ??
                      Colors.blue, // Change this to your preferred color
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
