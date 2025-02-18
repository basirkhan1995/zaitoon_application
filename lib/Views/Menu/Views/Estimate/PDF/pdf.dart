import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class Pdf {
  final pdf = Document();

  //PDF Directory
  late String _directoryPath;
  String get directoryPath => _directoryPath;

  // Declare variables for fonts
  static late Font _englishFont;
  static late Font _persianFont;

  // Getter for Persian font
  static Font get persianGlobalFont => _persianFont;

  // Getter for English font
  static Font get englishGlobalFont => _englishFont;

  // Method to load English Persian font
  static Future<void> loadEnglishFont() async {
    final ByteData englishFontData =
        await rootBundle.load('assets/fonts/NotoSans/NotoSans-Regular.ttf');
    final Uint8List englishBytes = englishFontData.buffer.asUint8List();
    _englishFont = Font.ttf(englishBytes.buffer.asByteData());
  }

  static Future<void> loadPersianFont() async {
    final ByteData persianFontData = await rootBundle.load(
        'assets/fonts/Amiri/Amiri-Regular.ttf'); // Ensure you have Persian font in assets
    final Uint8List persianBytes = persianFontData.buffer.asUint8List();
    _persianFont = Font.ttf(persianBytes.buffer.asByteData());
  }

  Future<void> createInvoice(
      {required String language, required PageOrientation orientaion}) async {
    pdf.addPage(MultiPage(
      textDirection: pdfLanguage(language: language),
      orientation: orientaion,
      build: (context) => [body()],
      header: (context) => header(),
      footer: (context) => footer(),
    ));

    // Preview the PDF
    //await previewPdf();
    await saveDocument(suggestedName: "Invoice.pdf", pdf: pdf);
  }

  static body() {
    final text = 'body is here';
    return Column(children: [
      Text(text,
          style: textStyle(text: text),
          textDirection: textDirection(text: text)),
    ]);
  }

  static Widget header() {
    final text = "English Content شرکت تکنالوزی زیتون";
    return Row(children: [
      Text(text,
          style: textStyle(text: text),
          textDirection: textDirection(text: text))
    ]);
  }

  static Widget footer() {
    final text = "Kabul, Afghanistan";
    return Row(children: [
      Text(text,
          style: textStyle(text: text),
          textDirection: textDirection(text: text))
    ]);
  }

  // Method to detect if the input is Persian (RTL)
  static bool _isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF]');
    return persianRegex.hasMatch(text);
  }

  static TextDirection textDirection({required String text}) {
    bool persian = _isPersian(text);
    return persian ? TextDirection.rtl : TextDirection.ltr;
  }

  static TextDirection pdfLanguage({required String language}) {
    return language == 'English' ? TextDirection.ltr : TextDirection.rtl;
  }

  static TextStyle textStyle({required String text}) {
    bool persian = _isPersian(text);
    return TextStyle(font: persian ? persianGlobalFont : englishGlobalFont);
  }

  static Future<File?> saveDocument({
    required String suggestedName,
    required Document pdf,
  }) async {
    try {
      // Open the native Save File dialog
      final FileSaveLocation? fileSaveLocation = await getSaveLocation(
        suggestedName: suggestedName, // Default file name
        acceptedTypeGroups: [
          const XTypeGroup(
            label: 'PDF Files', // Label for file types
            extensions: ['pdf'], // Limit to .pdf files
          ),
        ],
      );

      // If the user cancels the dialog, fileSaveLocation will be null
      if (fileSaveLocation == null) {
        return null;
      }

      // Ensure the file path has a .pdf extension
      String filePath = fileSaveLocation.path;
      if (!filePath.toLowerCase().endsWith('.pdf')) {
        filePath += '.pdf'; // Append .pdf extension if missing
      }

      // Save the PDF document to the selected path
      final bytes = await pdf.save();

      // Write the bytes to the file
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return file; // Return the saved file
    } catch (e) {
      return null;
    }
  }

  // Method to preview the generated PDF
  Future<void> previewPdf() async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        // Return the generated PDF bytes here
        final pdfBytes = await pdf.save();
        return pdfBytes;
      },
    );
  }

  Future<void> print(
      {required Printer selectedPrinter, required String language}) async {
    pdf.addPage(MultiPage(
      textDirection: pdfLanguage(language: language),
      build: (context) => [body()],
      header: (context) => header(),
      footer: (context) => footer(),
    ));

    // Preview the PDF
    //await previewPdf();
    await Printing.directPrintPdf(
      printer: selectedPrinter,
      onLayout: (PdfPageFormat format) async {
        return pdf.save();
      },
    );
  }
}
