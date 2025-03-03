import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/currencies_drop.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Components/Widgets/underline_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Json/invoice_model.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/pdf.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Invoice/currency.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key});

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final formKey = GlobalKey<FormState>();
  final customer = TextEditingController();
  final invoiceNumber = TextEditingController();
  final dueDate = TextEditingController();
  final invoiceDate = TextEditingController();
  List<InvoiceItems> invoiceItems = [];

  final invoiceDetails = InvoiceDetails();
  final pdf = Pdf();
  @override
  void initState() {
    invoiceItems.add(InvoiceItems(controller: TextEditingController()));
    initialDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Top part of the screen (Items + Right Side)
          Expanded(
            child: Row(
              children: [
                // Left side (Items) - Takes up remaining space
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: AppBackground(
                          child: Center(child: Text("Items")),
                        ),
                      ),
                      AppBackground(
                        height: 100,
                        child: Center(child: Text("Items")),
                      ),
                    ],
                  ),
                ),
                // Right side (fixed width)
                rightSide(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rightSide(context) {
    final locale = AppLocalizations.of(context)!;
    return AppBackground(
      width: 270,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Wrap scrollable content with SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Currencies(
                      title: AppLocalizations.of(context)!.currency,
                      width: double.infinity,
                      radius: 4,
                      onSelected: (value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {});
                      },
                    ),
                    AppBackground(
                      height: 180,
                      margin: EdgeInsets.zero,
                      child: Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputFieldEntitled(
                              title: locale.invoiceDate,
                              isRequire: true,
                              compactMode: true,
                              readOnly: true,
                              controller: invoiceDate,
                              trailing: IconButton(
                                constraints: BoxConstraints(),
                                onPressed: () =>
                                    datePicker(context, dueDate, "invoiceDate"),
                                icon: Icon(Icons.date_range_rounded, size: 20),
                              )),
                          InputFieldEntitled(
                              title: locale.dueDate,
                              isRequire: true,
                              compactMode: true,
                              readOnly: true,
                              controller: dueDate,
                              trailing: IconButton(
                                constraints: BoxConstraints(),
                                onPressed: () =>
                                    datePicker(context, dueDate, "dueDate"),
                                icon: Icon(Icons.date_range_rounded, size: 20),
                              )),
                        ],
                      ),
                    ),
                    AppBackground(
                      height: 110,
                      margin: EdgeInsets.zero,
                      child: Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: InputFieldEntitled(
                              compactMode: true,
                              title: locale.tax,
                              iconSize: 15,
                              icon: Icons.percent,
                              onChanged: (value) {},
                            ),
                          ),
                          Expanded(
                            child: InputFieldEntitled(
                              title: locale.discount,
                              iconSize: 15,
                              compactMode: true,
                              icon: Icons.percent,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Side - CREATE PDF
            SizedBox(
              height: 45, // Fixed height for the PDF button
              child: ZOutlineButton(
                  width: double.infinity,
                  icon: FontAwesomeIcons.solidFilePdf,
                  label: Text("PDF"),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  void initialDate() {
    invoiceNumber.text = "INV000001";
    final now = DateTime.now();
    final defaultIssueDate = DateFormat('MMM dd, yyyy').format(now);
    final defaultDueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));

    // Set default values in text controllers
    invoiceDate.text = defaultIssueDate;
    dueDate.text = defaultDueDate;

    // Update the invoiceInfo object with default dates
    invoiceDetails.invoiceDate = DateFormat('MMM dd, yyyy').format(now);
    invoiceDetails.invoiceDueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));
  }

  Future<void> datePicker(BuildContext context,
      TextEditingController controller, String field) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;

        // Update the respective field in the model
        if (field == "invoiceDate") {
          invoiceDetails.invoiceDate = formattedDate;
        } else if (field == "dueDate") {
          invoiceDetails.invoiceDueDate = formattedDate;
        }
      });
    }
  }
}
