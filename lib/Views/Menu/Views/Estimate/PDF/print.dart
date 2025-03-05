import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:zaitoon_invoice/Bloc/LanguageCubit/PDF/pdf_language_cubit.dart';
import 'package:zaitoon_invoice/Bloc/Printer/printer_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Json/invoice_model.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/document_language.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/pdf.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/printers_drop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfPrintSetting extends StatefulWidget {
  final InvoiceDetails info;
  final List<InvoiceItems> items;
  const PdfPrintSetting({super.key, required this.info, required this.items});

  @override
  State<PdfPrintSetting> createState() => _PdfPrintSettingState();
}

class _PdfPrintSettingState extends State<PdfPrintSetting> {
  final formKey = GlobalKey<FormState>();
  final clientName = TextEditingController();
  final invoiceNumber = TextEditingController();
  final dueDate = TextEditingController();
  final issueDate = TextEditingController();

  // Track the current orientation
  pw.PageOrientation selectedOrientation = pw.PageOrientation.portrait;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero, // Removes padding around the title
      actionsPadding: EdgeInsets.zero,

      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      content: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height * .9,
        width: MediaQuery.sizeOf(context).width * .9,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            //Title
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.surface),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.print),
                        const SizedBox(width: 10),
                        Text(
                          locale.printPreview,
                          style: const TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [box(), Expanded(child: printPreview())],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget printPreview() {
    return BlocBuilder<PrinterCubit, Printer?>(
      builder: (context, selectedPrinter) {
        return BlocBuilder<PDFLanguageCubit, String?>(
          builder: (context, selectedLanguage) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 0,
                        color: Colors.grey.withValues(alpha: .3))
                  ]),
              child: PdfPreview(
                padding: EdgeInsets.zero,
                useActions: false,
                previewPageMargin: EdgeInsets.zero,
                maxPageWidth: double.infinity,
                dynamicLayout: true,
                shouldRepaint: true,
                canChangeOrientation: true,
                pdfPreviewPageDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                build: (context) async {
                  // Generate a new document each time based on the selected printer and language
                  final document = await Pdf().printPreview(
                      language: selectedLanguage ?? "English",
                      orientation: selectedOrientation,
                      info: widget.info,
                      items: widget.items);
                  return document.save(); // Save and return the document
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget box() {
    final locale = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: 230,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 0,
                color: Colors.grey.withValues(alpha: .3))
          ]),
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Printer Dropdown
          BlocBuilder<PrinterCubit, Printer?>(
            builder: (context, selectedPrinter) {
              return PrintersDropdown(
                title: locale.printer,
                onSelected: (Printer printer) {
                  // Update printer state
                  context.read<PrinterCubit>().setPrinter(printer);
                },
              );
            },
          ),

          // Language Selection
          BlocBuilder<PDFLanguageCubit, String?>(
            builder: (context, selectedLanguage) {
              return PdfLanguageSelection(
                title: locale.language,
                onSelected: (value) {
                  // Update language state
                  context.read<PDFLanguageCubit>().setLanguage(value);
                },
              );
            },
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                ZOutlineButton(
                    width: double.infinity,
                    height: 45,
                    icon: Icons.print,
                    label: Text(locale.print),
                    onPressed: () {
                      // Get the latest state values for printer and language
                      final selectedPrinter =
                          context.read<PrinterCubit>().state;
                      final selectedLanguage =
                          context.read<PDFLanguageCubit>().state;
                      Pdf().print(
                          selectedPrinter: selectedPrinter!,
                          language: selectedLanguage ?? "English",
                          orientation: selectedOrientation,
                          invoiceInfo: widget.info,
                          items: widget.items);
                    }),
                ZOutlineButton(
                    width: double.infinity,
                    height: 45,
                    icon: FontAwesomeIcons.solidFilePdf,
                    label: Text("PDF"),
                    onPressed: () {
                      final selectedLanguage =
                          context.read<PDFLanguageCubit>().state;
                      Pdf().createInvoice(
                        language: selectedLanguage ?? "English",
                        orientation: selectedOrientation,
                        info: widget.info,
                        items: widget.items,
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
