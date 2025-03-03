import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../../Bloc/EstimateBloc/bloc/estimate_bloc.dart';
import '../../../../Json/estimate.dart';
import '../Accounts/new_account.dart';
import '../Estimate/customer_searchable_field.dart';
import '../Estimate/products_textfield.dart';
import '../Products/new_product.dart';

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
  List<EstimateItemsModel> invoiceItems = [];

  final invoiceDetails = InvoiceDetails();
  final pdf = Pdf();
  @override
  void initState() {
    invoiceItems.add(EstimateItemsModel(controller: TextEditingController()));
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
          buildInvoice()

        ],
      ),
    );
  }

  Widget buildInvoice(){
    return Expanded(
      child: Row(
        children: [
          // Left side (Items) - Takes up remaining space
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: AppBackground(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInvoiceHeader(context),
                           
                        ],
                      )
                  ),
                ),
                AppBackground(
                  height: 150,
                  child: Center(child: Text("Items")),
                ),
              ],
            ),
          ),
          // Right side (fixed width)
          rightSide(context)
        ],
      ),
    );
  }

  Widget buildEstimateItems() {
    return BlocConsumer<EstimateBloc, EstimateState>(
      listener: (context, state) {
        if (state is EstimateItemsLoadedState) {
          invoiceItems = state.items;
        }
      },
      builder: (context, state) {
        if (state is EstimateItemsLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Form(
              key: formKey,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                columnWidths: const {
                  0: FixedColumnWidth(40), // Adjust width for the first column
                  1: FlexColumnWidth(10), // Item name gets more space
                  2: FixedColumnWidth(80), // Quantity
                  3: FixedColumnWidth(100), // Unit price
                  4: FixedColumnWidth(110), // Total
                  5: FixedColumnWidth(60), // Action Button
                },
                border: TableBorder.symmetric(
                  outside: BorderSide(
                      color: Colors.grey.withValues(alpha: .2),
                      width: 1), // Table border outline
                  inside: BorderSide.none, // No internal borders
                ),
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text("#",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                Theme.of(context).colorScheme.onPrimary)),
                      ),
                      Text(AppLocalizations.of(context)!.description,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.qty,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.rate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.total,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.action,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),

                  ...state.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    int rowNumber = index + 1;
                    final rowTotal = ((item.quantity * item.amount) -
                        ((item.quantity * item.amount) *
                            (item.discount / 100)) +
                        ((item.quantity * item.amount) * (item.tax / 100)))
                        .toStringAsFixed(2);
                    item.total = double.parse(rowTotal);
                    item.rowNumber = rowNumber;
                    item.focusNode ??= FocusNode();
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          child: Center(child: Text(rowNumber.toString())),
                        ),
                        ProductTextField(
                          end: IconButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              iconSize: 15,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NewProduct();
                                    });
                              },
                              icon: Icon(Icons.add_circle_outline_rounded)),
                          controller: item.controller,
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                              UpdateItemEvent(
                                index,
                                item.copyWith(
                                  itemId: value,
                                  itemName: item.controller!.text,
                                ),
                              ),
                            );
                          },
                          hintText: "",
                        ),

                        //QTY
                        UnderlineTextfield(
                          enabledColor: Colors.cyan,
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                              UpdateItemEvent(
                                index,
                                item.copyWith(
                                  quantity: int.tryParse(value) ??
                                      1, // Correct field parsing
                                ),
                              ),
                            );
                          },
                        ),
                        //Price
                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enabledColor: Colors.teal,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                              UpdateItemEvent(
                                index,
                                item.copyWith(
                                    amount: double.tryParse(value) ?? 0.00),
                              ),
                            );
                          },
                        ),

                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          readOnly: true,
                          title: "",
                          hintText: rowTotal,
                        ),
                        Center(
                          child: IconButton(
                            constraints: BoxConstraints(),
                            iconSize: 18,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade900,
                            ),
                            onPressed: () {
                              context
                                  .read<EstimateBloc>()
                                  .add(RemoveItemEvent(index));
                            },
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          );
        }
        return Container();
      },
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

  Widget buildInvoiceHeader(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UnderlineTextfield(
              width: 120,
              title: locale.invoiceNumber,
              isRequired: true,
              controller: invoiceNumber,
            ),
            SizedBox(width: 20),
            AccountSearchableInputField(
              width: 250,
              title: locale.customer,
              controller: customer,
              onChanged: (value) {
                setState(() {
                  invoiceDetails.clientName = customer.text;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return locale.required(locale.client);
                }
                return null;
              },
              isRequire: true,
              end: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 15,
                constraints: BoxConstraints(),
                icon: Icon(Icons.add_circle_outline_rounded),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return NewAccount();
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
