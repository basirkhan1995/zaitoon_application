import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/EstimateBloc/bloc/estimate_bloc.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Widgets/product_searchable_field.dart';
import 'package:zaitoon_invoice/Components/Widgets/underline_textfield.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/customer_searchable_field.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/estimate_pdf.dart';

class EstimateView extends StatefulWidget {
  const EstimateView({super.key});

  @override
  State<EstimateView> createState() => _EstimateViewState();
}

class _EstimateViewState extends State<EstimateView> {
  final formKey = GlobalKey<FormState>();
  final formKeyInvoiceItem = GlobalKey<FormState>();

  List<EstimateItemsModel> invoiceItems = [];

  final customer = TextEditingController();
  final invoiceNumber = TextEditingController();
  final dueDate = TextEditingController();
  final issueDate = TextEditingController();

  final estimatePdf = InvoiceComponents();
  final estimateDetails = EstimateModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      invoiceItems.add(EstimateItemsModel(controller: TextEditingController()));
      invoiceNumber.text = "INV000001";
      _setDefaultDate();

      context.read<EstimateBloc>().add(LoadItemsEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildAppBar(context),
          buildEstimate(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    List<String> headerTitles = [
      "#",
      AppLocalizations.of(context)!.itemName,
      AppLocalizations.of(context)!.qty,
      AppLocalizations.of(context)!.rate,
      AppLocalizations.of(context)!.tax,
      AppLocalizations.of(context)!.discount,
      AppLocalizations.of(context)!.total,
    ];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(locale.newEstimate, style: theme.titleLarge),
          ZOutlineButton(
              height: 45,
              width: 120,
              icon: FontAwesomeIcons.solidFilePdf,
              label: Text("PDF"),
              onPressed: () {
                BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, locale) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ZOutlineButton(
                        width: 100,
                        height: 40,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            estimatePdf.generateInvoice(
                                invoiceInfo: estimateDetails,
                                invoiceItems: invoiceItems,
                                headerTitles: headerTitles,
                                appLanguage: locale.languageCode,
                                customerTitle: "Customer",
                                supplierTitle: "Supplier",
                                discountTitle:
                                    AppLocalizations.of(context)!.discount,
                                totalTitle: AppLocalizations.of(context)!.total,
                                subtotalTitle: "Subtotal",
                                vatTitle: "Vat",
                                termsAndConditionTitle: "terms and condition");
                          }
                        },
                        icon: FontAwesomeIcons.solidFilePdf,
                        label: const Text("PDF"),
                      ),
                    );
                  },
                );
              })
        ],
      ),
    );
  }

  Widget buildEstimate(BuildContext context) {
    return AppBackground(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          _buildInvoiceHeader(context),
          buildEstimateItems(),
          buildTotal(invoiceItems: invoiceItems, info: estimateDetails)
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 20,
          children: [
            UnderlineTextfield(
              title: locale.invoiceNumber,
              isRequired: true,
            ),
            AccountSearchableInputField(
              title: locale.customer,
              controller: customer,
              isRequire: true,
            ),
          ],
        ),
        Column(
          spacing: 20,
          children: [
            UnderlineTextfield(
              title: locale.invoiceDate,
              isRequired: true,
              controller: issueDate,
              onTap: () => _selectDate(context, issueDate, "issueDate"),
            ),
            UnderlineTextfield(
              title: locale.dueDate,
              isRequired: true,
              controller: dueDate,
              onTap: () => _selectDate(context, dueDate, "dueDate"),
            ),
          ],
        ),
      ],
    );
  }

  void _setDefaultDate() {
    final now = DateTime.now();
    final defaultIssueDate = DateFormat('MMM dd, yyyy').format(now);
    final defaultDueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));

    // Set default values in text controllers
    issueDate.text = defaultIssueDate;
    dueDate.text = defaultDueDate;

    // Update the invoiceInfo object with default dates
    estimateDetails.invoiceDate = DateFormat('MMM dd, yyyy').format(now);
    estimateDetails.dueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));
  }

  Future<void> _selectDate(BuildContext context,
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
        if (field == "issueDate") {
          estimateDetails.invoiceDate = formattedDate;
        } else if (field == "dueDate") {
          estimateDetails.dueDate = formattedDate;
        }
      });
    }
  }

  Widget buildTotal(
      {required List<EstimateItemsModel> invoiceItems,
      required EstimateModel info}) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      double calculateSubtotal() {
        double subtotal = 0.0;
        for (var item in invoiceItems) {
          subtotal += item.quantity * item.amount;
        }
        return subtotal;
      }

      double calculateTotalVat() {
        double totalVat = 0.0;
        for (var item in invoiceItems) {
          totalVat += (item.quantity * item.amount) * (item.tax / 100);
        }
        return totalVat;
      }

      double calculateDiscount() {
        double totalDiscount = 0.0;
        for (var item in invoiceItems) {
          totalDiscount +=
              (item.quantity * item.amount) * (item.discount / 100);
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

      String? currency;
      if (state is AuthenticatedState) {
        currency = "USD";
        info.currency = "USD";
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal"),
                    Text("${subtotal.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.tax),
                    Text("${totalVat.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.discount),
                    Text("${totalDiscount.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.primary),
                  child: Text(
                    "${AppLocalizations.of(context)!.total}: ${total.toStringAsFixed(2)} $currency",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget buildEstimateItems() {
    return BlocConsumer<EstimateBloc, EstimateState>(
      listener: (context, state) {
        if (state is InvoiceItemsLoadedState) {
          invoiceItems = state.items;
        }
      },
      builder: (context, state) {
        if (state is InvoiceItemsLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
            child: Form(
              key: formKeyInvoiceItem,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                columnWidths: const {
                  0: FixedColumnWidth(40), // Adjust width for the first column
                  1: FlexColumnWidth(10), // Item name gets more space
                  2: FixedColumnWidth(80), // Quantity
                  3: FixedColumnWidth(100), // Unit price
                  4: FixedColumnWidth(100), // Discount
                  5: FixedColumnWidth(80), // Tax
                  6: FixedColumnWidth(110), // Total
                  7: FixedColumnWidth(60), // Action Button
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.rate,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.discount,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.tax,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.total,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text("Action",
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Center(child: Text(rowNumber.toString())),
                        ),
                        ProductSearchableField(
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
                          title: "",
                        ),
                        UnderlineTextfield(
                          enabledColor: Colors.cyan,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        quantity: int.tryParse(value) ?? 1),
                                  ),
                                );
                          },
                        ),
                        UnderlineTextfield(
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
                          enabledColor: Colors.green,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        discount:
                                            double.tryParse(value) ?? 0.0),
                                  ),
                                );
                          },
                        ),
                        UnderlineTextfield(
                          enabledColor: Colors.red,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        tax: double.tryParse(value) ?? 0.0),
                                  ),
                                );
                          },
                        ),
                        UnderlineTextfield(
                          readOnly: true,
                          title: "",
                          hintText: rowTotal,
                        ),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 25,
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
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
// import '../../../../Components/Widgets/underline_textfield.dart';
// import '../../../../Json/estimate_model.dart';
// import 'customer_searchable_field.dart';
// import 'estimate_pdf.dart';
//
// class EstimateView extends StatefulWidget {
//   const EstimateView({super.key});
//
//   @override
//   State<EstimateView> createState() => _EstimateViewState();
// }
//
// class _EstimateViewState extends State<EstimateView> {
//   final invoiceNumber = TextEditingController();
//   final issueDate = TextEditingController();
//   final dueDate = TextEditingController();
//   final clientCtrl = TextEditingController();
//   final invoiceInfo = InvoiceInfo();
//   int? vendorId;
//   int? invoiceId;
//   int? termId;
//   int currencyId = 1;
//
//   final formKey = GlobalKey<FormState>();
//   final formKeyInvoiceItem = GlobalKey<FormState>();
//   List<Invoice> invoiceItems = [];
//
//   @override
//   void initState() {
//     _loadNextInvoiceId();
//     _setDefaultDate();
//
//     invoiceItems.add(Invoice(controller: TextEditingController())); // Add one empty row initially
//
//     WidgetsBinding.instance.addPostFrameCallback((e) {
//       context.read<InvoiceItemBloc>().add(LoadItemsEvent());
//       context.read<TermsConditionCubit>().getTermsEvent();
//     });
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     final localization = AppLocalizations.of(context)!;
//
//     List<String> headerTitles = [
//       "#",
//       localization.itemName,
//       localization.qty,
//       localization.rate,
//       localization.tax,
//       localization.discount,
//       localization.total,
//     ];
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
//       body: BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, state) {
//           if (state is AuthenticatedState) {
//             //invoiceInfo.currency = state.user.currencyCode ?? "";
//             invoiceInfo.supplier = state.user.businessName ?? "";
//             invoiceInfo.supplierAddress = state.user.address ?? "";
//             invoiceInfo.supplierMobile = state.user.mobile1 ?? "";
//             invoiceInfo.supplierTelephone = state.user.mobile2 ?? "";
//             invoiceInfo.logo = state.user.companyLogo;
//             invoiceInfo.supplierEmail = state.user.email ?? "";
//           }
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _actionButton(headerTitles),
//                   const SizedBox(height: 15),
//                   Container(
//                     margin: const EdgeInsets.all(4),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.surface,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Column(
//                       children: [
//                         _invoiceHeader(),
//                         _invoiceItemsTable(),
//                         _invoiceFooter(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _invoiceHeader() {
//     return Form(
//       key: formKey,
//       child: Padding(
//         padding: const EdgeInsets.only(right: 15.0),
//         child: Column(
//           children: [
//             Row(
//               spacing: 55,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   spacing: 15,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.sizeOf(context).width * .2,
//                       child: UnderlineTextfield(
//                         onChanged: (value) {
//                           setState(() {
//                             invoiceInfo.invoiceNumber = invoiceNumber.text;
//                           });
//                         },
//                         readOnly: true,
//                         enabledColor: Theme.of(context).colorScheme.primary,
//                         controller: invoiceNumber,
//                         title: AppLocalizations.of(context)!.invoiceNumber,
//                       ),
//                     ),
//                     SizedBox(
//                         width: MediaQuery.sizeOf(context).width * .22,
//                         child: ClientSearchableField(
//                             onChanged: (value) {
//                               setState(() {
//                                 vendorId = int.parse(value);
//                                 invoiceInfo.clientName = clientCtrl.text;
//                               });
//                             },
//                             isRequire: true,
//                             hintText: AppLocalizations.of(context)!.customer,
//                             controller: clientCtrl,
//                             title: AppLocalizations.of(context)!.customer)),
//                   ],
//                 ),
//                 Column(
//                   spacing: 15,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.sizeOf(context).width * .12,
//                       child: UnderlineTextfield(
//                           onChanged: (value) {
//                             setState(() {
//                               invoiceInfo.invoiceDate = issueDate.text;
//                             });
//                           },
//                           onTap: () =>
//                               _selectDate(context, issueDate, "invoice date"),
//                           isRequired: true,
//                           hintText: AppLocalizations.of(context)!.invoiceDate,
//                           enabledColor: Theme.of(context).colorScheme.onSurface,
//                           controller: issueDate,
//                           title: AppLocalizations.of(context)!.invoiceDate),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.sizeOf(context).width * .12,
//                       child: UnderlineTextfield(
//                           onChanged: (value) {
//                             setState(() {
//                               invoiceInfo.dueDate = dueDate.text;
//                             });
//                           },
//                           onTap: () => _selectDate(context, dueDate, "dueDate"),
//                           readOnly: true,
//                           isRequired: true,
//                           enabledColor: Theme.of(context).colorScheme.onSurface,
//                           controller: dueDate,
//                           hintText: AppLocalizations.of(context)!.dueDate,
//                           title: AppLocalizations.of(context)!.dueDate),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _invoiceItemsTable() {
//     return BlocConsumer<InvoiceItemBloc, InvoiceItemState>(
//       listener: (context, state) {
//         if (state is InvoiceItemsLoadedState) {
//           invoiceItems = state.items;
//         }
//       },
//       builder: (context, state) {
//         if (state is InvoiceItemsLoadedState) {
//           return Padding(
//             padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
//             child: Form(
//               key: formKeyInvoiceItem,
//               child: Table(
//                 defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
//                 columnWidths: const {
//                   0: FixedColumnWidth(40), // Adjust width for the first column
//                   1: FlexColumnWidth(10), // Item name gets more space
//                   2: FixedColumnWidth(80), // Quantity
//                   3: FixedColumnWidth(100), // Unit price
//                   4: FixedColumnWidth(100), // Discount
//                   5: FixedColumnWidth(80), // Tax
//                   6: FixedColumnWidth(110), // Total
//                   7: FixedColumnWidth(60), // Action Button
//                 },
//                 border: TableBorder.symmetric(
//                   outside: BorderSide(
//                       color: Colors.grey.withValues(alpha: .2),
//                       width: 1), // Table border outline
//                   inside: BorderSide.none, // No internal borders
//                 ),
//                 children: [
//                   // Header Row
//                   TableRow(
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary),
//                     children: [
//                       Align(
//                         alignment: Alignment.center,
//                         child: Text("#",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color:
//                                 Theme.of(context).colorScheme.onPrimary)),
//                       ),
//                       Text(AppLocalizations.of(context)!.itemDescription,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.qty,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.rate,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.discount,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.tax,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.total,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                       Text(AppLocalizations.of(context)!.action,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onPrimary)),
//                     ],
//                   ),
//                   ...state.items.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final item = entry.value;
//
//                     int rowNumber = index + 1;
//                     final rowTotal = ((item.quantity * item.amount) -
//                         ((item.quantity * item.amount) *
//                             (item.discount / 100)) +
//                         ((item.quantity * item.amount) * (item.tax / 100)))
//                         .toStringAsFixed(2);
//                     item.total = double.parse(rowTotal);
//                     item.rowNumber = rowNumber;
//                     item.focusNode ??= FocusNode();
//                     return TableRow(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Center(child: Text(rowNumber.toString())),
//                         ),
//                         ItemsSearchableField(
//                           controller: item.controller,
//                           onChanged: (value) {
//                             context.read<InvoiceItemBloc>().add(
//                               UpdateItemEvent(
//                                 index,
//                                 item.copyWith(
//                                   itemId: value,
//                                   itemName: item.controller!.text,
//                                 ),
//                               ),
//                             );
//                           },
//                           hintText: "",
//                           title: "",
//                         ),
//                         UnderlineTextfield(
//                           enabledColor: Colors.cyan,
//                           title: "",
//                           onChanged: (value) {
//                             context.read<InvoiceItemBloc>().add(
//                               UpdateItemEvent(
//                                 index,
//                                 item.copyWith(
//                                     quantity: int.tryParse(value) ?? 1),
//                               ),
//                             );
//                           },
//                         ),
//                         UnderlineTextfield(
//                           enabledColor: Colors.teal,
//                           title: "",
//                           onChanged: (value) {
//                             context.read<InvoiceItemBloc>().add(
//                               UpdateItemEvent(
//                                 index,
//                                 item.copyWith(
//                                     amount: double.tryParse(value) ?? 0.00),
//                               ),
//                             );
//                           },
//                         ),
//                         UnderlineTextfield(
//                           enabledColor: Colors.green,
//                           title: "",
//                           onChanged: (value) {
//                             context.read<InvoiceItemBloc>().add(
//                               UpdateItemEvent(
//                                 index,
//                                 item.copyWith(
//                                     discount:
//                                     double.tryParse(value) ?? 0.0),
//                               ),
//                             );
//                           },
//                         ),
//                         UnderlineTextfield(
//                           enabledColor: Colors.red,
//                           title: "",
//                           onChanged: (value) {
//                             context.read<InvoiceItemBloc>().add(
//                               UpdateItemEvent(
//                                 index,
//                                 item.copyWith(
//                                     tax: double.tryParse(value) ?? 0.0),
//                               ),
//                             );
//                           },
//                         ),
//                         UnderlineTextfield(
//                           readOnly: true,
//                           title: "",
//                           hintText: rowTotal,
//                         ),
//                         Center(
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.delete,
//                               size: 25,
//                               color: Colors.red.shade900,
//                             ),
//                             onPressed: () {
//                               context
//                                   .read<InvoiceItemBloc>()
//                                   .add(RemoveItemEvent(index));
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   })
//                 ],
//               ),
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }
//
//   Widget _actionButton(List<String> headerTitles) {
//     final invoice = InvoiceComponents(AppLocalizations.of(context)!);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14.0),
//             child: Text(
//               AppLocalizations.of(context)!.newInvoice,
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 BlocBuilder<LanguageCubit, Locale>(
//                   builder: (context, locale) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10.0, vertical: 5),
//                       child: OutButton(
//                         width: 100,
//                         height: 40,
//                         onPressed: () {
//                           if (formKey.currentState!.validate()) {
//                             invoice.generateInvoice(
//                               invoiceInfo: invoiceInfo,
//                               invoiceItems: invoiceItems,
//                               headerTitles: headerTitles,
//                               appLanguage: locale.languageCode,
//                             );
//                           }
//                         },
//                         icon: FontAwesomeIcons.solidFilePdf,
//                         label: const Text("PDF"),
//                       ),
//                     );
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: OutButton(
//                     icon: FontAwesomeIcons.fileInvoice,
//                     label: Text(AppLocalizations.of(context)!.createInvoice),
//                     onPressed: () async {
//                       if (formKey.currentState!.validate() &&
//                           formKeyInvoiceItem.currentState!.validate()) {
//                         await context
//                             .read<InvoiceCubit>().addInvoice(
//                             termConditionId: termId!,
//                             status: 1,
//                             vendorId: vendorId!,
//                             currencyId: currencyId,
//                             issueDate: issueDate.text,
//                             dueDate: dueDate.text,
//                             items: invoiceItems).then((e) {
//                           setState(() {
//                             context.read<MenuBloc>().add(const OnChangedEvent(4));
//                           });
//                         });
//                       }
//                     },
//                     width: 167,
//                     height: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _invoiceFooter() {
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       context.read<InvoiceItemBloc>().add(AddItemEvent(invoiceItems));
//                     });
//                   },
//                   child: Chip(
//                       side: BorderSide.none,
//                       avatar: const Icon(Icons.add_circle_outline_rounded),
//                       label: Text(
//                         AppLocalizations.of(context)!.addNewLine,
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.primary),
//                       ))),
//               GestureDetector(
//                   onTap: () {
//                     ///Select Terms
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return TermsConditionView(
//                             onChanged: (value){
//                               invoiceInfo.termsAndCondition = value;
//                             },
//                             onChangedId: (value){
//                               termId = value;
//                             },
//                           );
//                         });
//                   },
//                   child: Chip(
//                       side: BorderSide.none,
//                       avatar: const Icon(Icons.add_circle_outline_rounded),
//                       label: Text(
//                         AppLocalizations.of(context)!.addTermsCondition,
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.primary),
//                       ))),
//             ],
//           ),
//           Expanded(child: BlocBuilder<InvoiceItemBloc, InvoiceItemState>(
//             builder: (context, state) {
//               if (state is InvoiceItemsLoadedState) {
//                 return buildTotal(invoiceItems: state.items, info: invoiceInfo);
//               }
//               return Container();
//             },
//           )),
//         ],
//       ),
//     );
//   }
//
//   //Not Used For Now
//   Widget buildTotal2(
//       {required List<Invoice> invoiceItems, required InvoiceInfo invoice}) {
//     double calculateSubtotal() {
//       double subtotal = 0.0;
//       for (var item in invoiceItems) {
//         subtotal += item.quantity * item.amount;
//       }
//       return subtotal;
//     }
//
//     double calculateTotalVat() {
//       double totalVat = 0.0;
//       for (var item in invoiceItems) {
//         totalVat += (item.quantity * item.amount) * (item.tax / 100);
//       }
//       return totalVat;
//     }
//
//     double calculateDiscount() {
//       double totalDiscount = 0.0;
//       for (var item in invoiceItems) {
//         totalDiscount += (item.quantity * item.amount) * (item.discount / 100);
//       }
//       return totalDiscount;
//     }
//
//     double calculateTotal() {
//       double subtotal = calculateSubtotal();
//       double totalVat = calculateTotalVat();
//       double totalDiscount = calculateDiscount();
//       return subtotal + totalVat - totalDiscount;
//     }
//
//     final subtotal = calculateSubtotal();
//     final totalTax = calculateTotalVat();
//     final discount = calculateDiscount();
//     final total = calculateTotal();
//     return Align(
//         alignment: Alignment.bottomRight,
//         child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 5),
//             width: 200,
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Subtotal:",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey.withValues(alpha: .9))),
//                         Text(
//                             "${subtotal.toStringAsFixed(2)} ${invoice.currency} ",
//                             style: const TextStyle(fontSize: 15)),
//                       ]),
//                   const SizedBox(height: 5),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("VAT:",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey.withValues(alpha: .9))),
//                         Text(
//                             "${totalTax.toStringAsFixed(2)} ${invoice.currency} ",
//                             style: const TextStyle(fontSize: 15)),
//                       ]),
//                   const SizedBox(height: 5),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Discount:",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey.withValues(alpha: .9))),
//                         Text(
//                             "${discount.toStringAsFixed(2)} ${invoice.currency} ",
//                             style: const TextStyle(fontSize: 15)),
//                       ]),
//                   const SizedBox(height: 5),
//                   Container(
//                       width: 200,
//                       height: 2,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                       )),
//                   const SizedBox(height: 5),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Total: ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).colorScheme.primary)),
//                         Text("${total.toStringAsFixed(2)} ${invoice.currency}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                                 color: Theme.of(context).colorScheme.primary)),
//                       ]),
//                 ])));
//   }
//
//   void _loadNextInvoiceId() async {
//     String nextInvoiceId = await Repository().getNextInvoiceId();
//     invoiceNumber.text = nextInvoiceId;
//     invoiceInfo.invoiceNumber = nextInvoiceId;
//   }
//
//   void _setDefaultDate() {
//     final now = DateTime.now();
//     final defaultIssueDate = DateFormat('MMM dd, yyyy').format(now);
//     final defaultDueDate =
//     DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));
//
//     // Set default values in text controllers
//     issueDate.text = defaultIssueDate;
//     dueDate.text = defaultDueDate;
//
//     // Update the invoiceInfo object with default dates
//     invoiceInfo.invoiceDate = DateFormat('MMM dd, yyyy').format(now);
//     invoiceInfo.dueDate =
//         DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));
//   }
//
//   Future<void> _selectDate(BuildContext context,
//       TextEditingController controller, String field) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
//       setState(() {
//         controller.text = formattedDate;
//
//         // Update the respective field in the model
//         if (field == "issueDate") {
//           invoiceInfo.invoiceDate = formattedDate;
//         } else if (field == "dueDate") {
//           invoiceInfo.dueDate = formattedDate;
//         }
//       });
//     }
//   }
//
//   Widget buildTotal(
//       {required List<Invoice> invoiceItems, required InvoiceInfo info}) {
//     return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
//       double calculateSubtotal() {
//         double subtotal = 0.0;
//         for (var item in invoiceItems) {
//           subtotal += item.quantity * item.amount;
//         }
//         return subtotal;
//       }
//
//       double calculateTotalVat() {
//         double totalVat = 0.0;
//         for (var item in invoiceItems) {
//           totalVat += (item.quantity * item.amount) * (item.tax / 100);
//         }
//         return totalVat;
//       }
//
//       double calculateDiscount() {
//         double totalDiscount = 0.0;
//         for (var item in invoiceItems) {
//           totalDiscount +=
//               (item.quantity * item.amount) * (item.discount / 100);
//         }
//         return totalDiscount;
//       }
//
//       double calculateTotal() {
//         double subtotal = calculateSubtotal();
//         double totalVat = calculateTotalVat();
//         double totalDiscount = calculateDiscount();
//         return subtotal + totalVat - totalDiscount;
//       }
//
//       final subtotal = calculateSubtotal();
//       final totalVat = calculateTotalVat();
//       final totalDiscount = calculateDiscount();
//       final total = calculateTotal();
//
//       String? currency;
//       if (state is AuthenticatedState) {
//         currency = state.users.currencyCode!;
//         info.currency = state.users.currencyCode ?? "";
//       }
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               spacing: 5,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   spacing: 5,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(AppLocalizations.of(context)!.subtotal),
//                     Text("${subtotal.toStringAsFixed(2)} $currency",
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Row(
//                   spacing: 5,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(AppLocalizations.of(context)!.tax),
//                     Text("${totalVat.toStringAsFixed(2)} $currency",
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Row(
//                   spacing: 5,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(AppLocalizations.of(context)!.discount),
//                     Text("${totalDiscount.toStringAsFixed(2)} $currency",
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(2),
//                       color: Theme.of(context).colorScheme.primary),
//                   child: Text(
//                     "${AppLocalizations.of(context)!.total}: ${total.toStringAsFixed(2)} $currency",
//                     style: TextStyle(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
