import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/document_language.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/pdf.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/printers_drop.dart';

class PdfPrintSetting extends StatefulWidget {
  const PdfPrintSetting({super.key});

  @override
  State<PdfPrintSetting> createState() => _PdfPrintSettingState();
}

class _PdfPrintSettingState extends State<PdfPrintSetting> {
  Printer? _selectedPrinter;
  String pdfSelectedLanguage = "English";
  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surface),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.print),
                        const SizedBox(width: 10),
                        Text(
                          "Print preview",
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
                children: [box(), Text("Hello pdf")],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget box() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: 230,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          PrintersDropdown(
            title: 'Printer',
            onSelected: (Printer selectedPrinter) {
              // Handle the selected printer
              setState(() {
                _selectedPrinter = selectedPrinter;
              });
            },
          ),
          PdfLanguageSelection(
              title: "Language",
              onSelected: (value) {
                pdfSelectedLanguage = value;
              }),
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
                  label: Text("Print"),
                  onPressed: () => Pdf().print(
                      selectedPrinter: _selectedPrinter!,
                      language: pdfSelectedLanguage),
                ),
                ZOutlineButton(
                  width: double.infinity,
                  height: 45,
                  icon: FontAwesomeIcons.solidFilePdf,
                  label: Text("PDF"),
                  onPressed: () => Pdf().createInvoice(
                      language: pdfSelectedLanguage,
                      orientaion: pw.PageOrientation.portrait),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
