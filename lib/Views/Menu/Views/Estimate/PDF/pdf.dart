import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

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

  static String dateTime = DateFormat("MM dd, yyyy | HH:mm:ss").format(DateTime.now());
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

  Future<Document> printPreview(
      {
      required String language,
      required PageOrientation orientation,
        required List<EstimateItemsModel> items,
      required EstimateInfoModel invoiceInfo}) async {
      final document = Document(); // Create a new document each time

    document.addPage(MultiPage(
      margin: EdgeInsets.zero,
      textDirection: pdfLanguage(language: language),
      orientation: orientation,
      build: (context) => [
        header(invoiceInfo: invoiceInfo,language: language),
        body(items: items, language: language),
      ],
      header: (context) => buildTopHeader(invoiceInfo: invoiceInfo,language: language),
      footer: (context) => footer(estimateInfo: invoiceInfo,language: language),
    ));

    return document; // Return the document without saving it
  }

  Future<void> createInvoice({
    required List<EstimateItemsModel> items,
    required EstimateInfoModel invoiceInfo,
    required String language,
    required PageOrientation orientation,
  }) async {
    try {
      final pdf = Document(); // Ensure a new instance is created

      pdf.addPage(MultiPage(
        margin: EdgeInsets.zero,
        textDirection: pdfLanguage(language: language),
        orientation: orientation,
        build: (context) => [body(items: items, language: language)],
        header: (context) => header(invoiceInfo: invoiceInfo,language: language),
        footer: (context) => footer(estimateInfo: invoiceInfo,language: language),
      ));
      // Check if the PDF has content before saving
      await saveDocument(suggestedName: "Invoice.pdf", pdf: pdf);
    } catch (e) {
      throw e.toString();
    }
  }

  static body({required List<EstimateItemsModel> items, required String language}) {
    final text = 'body is here';
    return Column(children: [
      buildTableHeader(items: items, language: language),
    ]);
  }

  static Widget header({required EstimateInfoModel invoiceInfo, required String language}) {
    final supplierTitleText = language == "English"? "Supplier" : language == "فارسی" ? "عرضه کننده" : language == "پشتو" ? "عرضه کونکی" : "Supplier";

    String clientTitleText = language == "English"? "Client" : language == "فارسی" ? "مشتری" : language == "پشتو" ? "پیرودونکی" : "Client";

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(color: PdfColors.cyan50),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //From
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplierTitleText,
                        style: textStyle(text: supplierTitleText),
                        textDirection: textDirection(text: supplierTitleText)),
                    SizedBox(height: 3),
                    buildTextWidget(
                    text: invoiceInfo.supplier),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplierEmail),
                    SizedBox(height: 5),
                    Text(invoiceInfo.supplierMobile),
                  ]),

              //To
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildTextWidget(text: clientTitleText),
                    SizedBox(height: 3),
                    Text(invoiceInfo.clientName, style: textStyle(text: invoiceInfo.clientName)),

                  ])
            ]));
  }

  static Widget footer({required EstimateInfoModel estimateInfo,required String language}) {
    final timeStampText = language == "English"? "Print time: " : language == "فارسی" ? "زمان چاپ: " : language == "پشتو" ? "چاپ وقت: " : "Client";

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 35,vertical: 20),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               buildTextWidget(text: timeStampText),
               SizedBox(width: 3),
               Text(dateTime.toString(),style: TextStyle(fontSize: 11)),
             ]
           ),
           Row(
               children: [
                 SizedBox(height: 2 * PdfPageFormat.mm),
                 buildTextWidget(text: estimateInfo.supplierMobile),
                 verticalDividerWidget(width: 1, height: 15),
                 buildTextWidget(text: estimateInfo.supplierEmail),
                 estimateInfo.supplierEmail.isNotEmpty? verticalDividerWidget(width: 1, height: 15) : SizedBox(),
                 buildTextWidget(text: estimateInfo.supplierAddress),
               ]),
         ]
       )
    );
  }

  // Method to detect if the input is Persian (RTL)
  static bool _isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF]');
    return persianRegex.hasMatch(text);
  }

  static pw.TextDirection textDirection({required String text}) {
    bool persian = _isPersian(text);
    return persian ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  }

  static pw.TextDirection pdfLanguage({required String language}) {
    return language == 'English' ? pw.TextDirection.ltr : pw.TextDirection.rtl;
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

  //Print PDF
  Future<void> print(
      {required Printer selectedPrinter,
      required String language,
      required EstimateInfoModel invoiceInfo,
      required List<EstimateItemsModel> items,
      required PageOrientation orientation}) async {
    pdf.addPage(MultiPage(
      textDirection: pdfLanguage(language: language),
      orientation: orientation,
      build: (context) => [
        header(invoiceInfo: invoiceInfo,language: language),
        body(items: items,language: language),
      ],
      header: (context) => buildTopHeader(invoiceInfo: invoiceInfo,language: language),
      footer: (context) => footer(estimateInfo: invoiceInfo,language: language),
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

  static Widget buildTopHeader(
      {required EstimateInfoModel invoiceInfo,required String language}) {
    final image = invoiceInfo.logo != null && invoiceInfo.logo!.isNotEmpty
        ? MemoryImage(invoiceInfo.logo!)
        : null;
    String invoiceDateText =  language == "English"? "Invoice Date" : language == "فارسی" ? "تاریخ بل" : language == "پشتو" ? "بل نیته" : "Date";
    String invoiceNumberText =  language == "English"? "Invoice Number" : language == "فارسی" ? "شماره بل" : language == "پشتو" ? "بل شمیره" : "Invoice Number";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Beginning
          Column(
            children: [
              Row(children: [
                image == null
                    ? buildTextWidget(text: invoiceInfo.supplier)
                    : Image(
                  image,
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                ),
                image != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextWidget(text: invoiceInfo.supplier),
                        SizedBox(height: 2),
                        Text(invoiceInfo.supplierMobile,
                            style: const TextStyle(fontSize: 10)),
                        SizedBox(height: 2),
                        Text(invoiceInfo.supplierEmail,
                            style: TextStyle(fontSize: 10)),
                      ]),
                )
                    : SizedBox()
              ])
            ],
          ),

          // End
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Title
                  buildTextWidget(text: invoiceDateText),
                  //Data
                  Text(
                    invoiceInfo.invoiceDate,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: PdfColors.cyan),
                  ),
                ],
              ),
              SizedBox(width: 5),
              verticalDividerWidget(width: 1, height: 30),
              SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildTextWidget(text: invoiceNumberText),
                  Text(
                    invoiceInfo.invoiceNumber,
                    style: TextStyle(
                      color: PdfColors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget verticalDividerWidget(
      {required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      color: PdfColors.grey300, // Divider color
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    );
  }

  static Widget buildTextWidget({required text}){
    return Text(text,style: textStyle(text: text), textDirection: textDirection(text: text));
  }

  static Widget buildTableHeader({
    required List<EstimateItemsModel> items,
    required String language,
  }) {
    final Map<String, List<String>> titles = {
      "English": ["NO", "Description", "QTY", "Rate", "Tax", "Discount", "Total"],
      "فارسی": ["ردیف", "توضیحات", "تعداد", "نرخ", "مالیات", "تخفیف", "مجموع"],
      "پشتو": ["شمېره", "توضیحات", "شمېر", "نرخ", "مالیه", "تخفیف", "مجموع"],
    };

    // Get the correct language titles and reverse them if Persian or Pashto
    List<String> localizedTitles = (language == "English")
        ? titles[language]!
        : titles[language]!.reversed.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          TableHelper.fromTextArray(
            tableDirection: language == "English"
      ? pw.TextDirection.ltr
          : pw.TextDirection.rtl,
            headerDirection: language == "English"
                ? pw.TextDirection.ltr
                : pw.TextDirection.rtl, // Force RTL for Persian & Pashto
            cellStyle: pw.TextStyle(),
            headerStyle: textStyle(text: localizedTitles.first),
            oddRowDecoration: const BoxDecoration(
              color: PdfColors.cyan50,
            ),
            headerDecoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PdfColors.cyan, // Set your preferred color here
                  width: 1.7, // Set your preferred width here
                ),
              ),
            ),
            border: null, // Disable default borders
            headerHeight: 35,
            columnWidths: language == "English"
                ? {
              0: const pw.FixedColumnWidth(35),
              1: const pw.FlexColumnWidth(10),
              2: const pw.FixedColumnWidth(50),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(50),
              5: const pw.FixedColumnWidth(65),
              6: const pw.FixedColumnWidth(70),
            }
                : {
              6: const pw.FixedColumnWidth(35),
              5: const pw.FlexColumnWidth(10),
              4: const pw.FixedColumnWidth(50),
              3: const pw.FixedColumnWidth(70),
              2: const pw.FixedColumnWidth(50),
              1: const pw.FixedColumnWidth(65),
              0: const pw.FixedColumnWidth(70),
            },
            cellAlignments: language == "English"
                ? {
              0: pw.Alignment.centerLeft, // Row number
              1: pw.Alignment.centerLeft, // Item name
              2: pw.Alignment.center, // Quantity
              3: pw.Alignment.center, // Unit price
              4: pw.Alignment.center, // Tax
              5: pw.Alignment.center, // Discount
              6: pw.Alignment.centerRight, // Total
            }
                : {
              6: pw.Alignment.centerLeft, // Total
              5: pw.Alignment.center, // Discount
              4: pw.Alignment.center, // Tax
              3: pw.Alignment.center, // Unit price
              2: pw.Alignment.center, // Quantity
              1: pw.Alignment.centerRight, // Item name
              0: pw.Alignment.centerRight, // Row number
            },
            headers: localizedTitles, // Reversed headers for Persian/Pashto
            data: items.map((e) {
              final row = [
                e.rowNumber,
                e.itemName,
                e.quantity,
                e.amount,
                e.tax,
                e.discount,
                e.total,
              ];
              return language == "English" ? row : row.reversed.toList();
            }).toList(),
          ),
          // Add a border under the table header
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 1.5, // Adjust thickness of the line
            width: double.infinity,
            color: PdfColors.cyan, // Set border color
          ), // Optional spacing after the border
        ],
      ),
    );
  }


}
