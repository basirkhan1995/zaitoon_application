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

  static String dateTime =
      DateFormat("MM/dd/yyyy | HH:mm:ss").format(DateTime.now());
  // Method to load English Persian font
  static Future<void> loadEnglishFont() async {
    final ByteData englishFontData =
        await rootBundle.load('assets/fonts/OpenSans/OpenSans-Regular.ttf');
    final Uint8List englishBytes = englishFontData.buffer.asUint8List();
    _englishFont = Font.ttf(englishBytes.buffer.asByteData());
  }

  static Future<void> loadPersianFont() async {
    final ByteData persianFontData = await rootBundle.load(
        'assets/fonts/Amiri/Amiri-Regular.ttf'); // Ensure you have Persian font in assets
    final Uint8List persianBytes = persianFontData.buffer.asUint8List();
    _persianFont = Font.ttf(persianBytes.buffer.asByteData());
  }

  Future<Document> generateEstimate(
      {required String language,
        required PageOrientation orientation,
        required List<EstimateItemsModel> items,
        required EstimateInfoModel info}) async {
    final document = Document(); // Create a new document each time

    document.addPage(MultiPage(
      margin: EdgeInsets.zero,
      textDirection: pdfLanguage(language: language),
      orientation: orientation,
      build: (context) => [
        header(invoiceInfo: info, language: language),
        body(items: items, language: language),
        buildTotal(items: items, info: info, language: language)
      ],
      header: (context) =>
          buildTopHeader(invoiceInfo: info, language: language),
      footer: (context) =>
          footer(estimateInfo: info, language: language),
    ));

    return document; // Return the document without saving it
  }


  Future<Document> printPreview({
      required String language,
      required PageOrientation orientation,
      required List<EstimateItemsModel> items,
      required EstimateInfoModel info}) async {
    return generateEstimate(
        language: language,
        orientation: orientation,
        items: items,
        info: info);
  }

  Future<void> createInvoice({
    required List<EstimateItemsModel> items,
    required EstimateInfoModel info,
    required String language,
    required PageOrientation orientation,
  }) async {
    try {
      final document = await generateEstimate(
        items: items,
        info: info,
        language: language,
        orientation: orientation,
      );

      // Save the document
      await saveDocument(suggestedName: "Invoice.pdf", pdf: document);
    } catch (e) {
      throw e.toString();
    }
  }


  //Print PDF
  Future<void> print({
    required Printer selectedPrinter,
    required String language,
    required EstimateInfoModel invoiceInfo,
    required List<EstimateItemsModel> items,
    required PageOrientation orientation,
  }) async {
    final document = await generateEstimate(
      items: items,
      info: invoiceInfo,
      language: language,
      orientation: orientation,
    );

    await Printing.directPrintPdf(
      printer: selectedPrinter,
      onLayout: (PdfPageFormat format) async {
        return document.save();
      },
    );
  }


  static body(
      {required List<EstimateItemsModel> items, required String language}) {
    return Column(children: [
      buildTableHeader(items: items, language: language),
    ]);
  }

  static Widget header(
      {required EstimateInfoModel invoiceInfo, required String language}) {
    final supplierTitleText = language == "English"
        ? "Supplier"
        : language == "فارسی"
            ? "عرضه کننده"
            : language == "پشتو"
                ? "عرضه کونکی"
                : "Supplier";

    String clientTitleText = language == "English"
        ? "Client"
        : language == "فارسی"
            ? "مشتری"
            : language == "پشتو"
                ? "پیرودونکی"
                : "Client";

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
                    buildTextWidget(text: invoiceInfo.supplier),
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
                    buildTextWidget(text: invoiceInfo.clientName),
                  ])
            ]));
  }

  static Widget footer(
      {required EstimateInfoModel estimateInfo, required String language}) {
    final timeStampText = language == "English"
        ? "Print time: "
        : language == "فارسی"
            ? "زمان چاپ: "
            : language == "پشتو"
                ? "چاپ وقت: "
                : "Client";

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                buildTextWidget(text: timeStampText),
                SizedBox(width: 3),
                Text(dateTime.toString(), style: TextStyle(fontSize: 11)),
              ]),
              Row(children: [
                SizedBox(height: 2 * PdfPageFormat.mm),
                buildTextWidget(text: estimateInfo.supplierMobile),
                verticalDividerWidget(width: 1, height: 15),
                buildTextWidget(text: estimateInfo.supplierEmail),
                estimateInfo.supplierEmail.isNotEmpty
                    ? verticalDividerWidget(width: 1, height: 15)
                    : SizedBox(),
                buildTextWidget(text: estimateInfo.supplierAddress),
              ]),
            ]));
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

  static TextStyle textStyle({required String text, double? fontSize}) {
    bool persian = _isPersian(text);
    return TextStyle(
        font: persian ? persianGlobalFont : englishGlobalFont,
        fontSize: fontSize);
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



  static Widget buildTopHeader(
      {required EstimateInfoModel invoiceInfo, required String language}) {
    final image = invoiceInfo.logo != null && invoiceInfo.logo!.isNotEmpty
        ? MemoryImage(invoiceInfo.logo!)
        : null;
    String invoiceDateText = language == "English"
        ? "Invoice Date"
        : language == "فارسی"
            ? "تاریخ بل"
            : language == "پشتو"
                ? "بل نیته"
                : "Date";
    String invoiceNumberText = language == "English"
        ? "Invoice Number"
        : language == "فارسی"
            ? "شماره بل"
            : language == "پشتو"
                ? "بل شمیره"
                : "Invoice Number";

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
                  buildTextWidget(text: invoiceDateText, fontSize: 12),
                  //Data
                  Text(
                    invoiceInfo.invoiceDate,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: PdfColors.black,
                        fontSize: 10),
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
                  buildTextWidget(text: invoiceNumberText, fontSize: 12),
                  Text(
                    invoiceInfo.invoiceNumber,
                    style: TextStyle(
                        color: PdfColors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
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

  static Widget buildTextWidget({required String text, double? fontSize}) {
    return Text(text,
        style: textStyle(text: text, fontSize: fontSize),
        textDirection: textDirection(text: text));
  }

  static Widget buildTableHeader({
    required List<EstimateItemsModel> items,
    required String language,
  }) {
    final Map<String, List<String>> titles = {
      "English": [
        "#",
        "Item Description",
        "QTY",
        "Rate",
        "Tax",
        "Discount",
        "Total"
      ],
      "فارسی": ["#", "توضیحات", "تعداد", "نرخ", "مالیات", "تخفیف", "مجموع"],
      "پشتو": ["#", "توضیحات", "شمېر", "نرخ", "مالیه", "تخفیف", "مجموع"],
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

            headerStyle: textStyle(text: localizedTitles.first, fontSize: 10),
            oddRowDecoration: const BoxDecoration(
              color: PdfColors.cyan50,
            ),
            headerDecoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PdfColors.cyan, // Set your preferred color here
                  width: 1.5, // Set your preferred width here
                ),
              ),
            ),
            border: null, // Disable default borders
            headerHeight: 30,
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
                    0: pw.Alignment.center, // Row number
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
                    0: pw.Alignment.center, // Row number
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
              // Reverse row data for Persian/Pashto
              final languageAdjustedRow =
                  language == "English" ? row : row.reversed.toList();
              // Return each row with the proper textStyle for each cell
              return languageAdjustedRow.map((cell) {
                return buildTextWidget(text: cell.toString(), fontSize: 10);
              }).toList();
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

  static Widget buildTotal({
    required List<EstimateItemsModel> items,
    required EstimateInfoModel info,
    required String language,
  }) {
    String vatTitle = language == "English"
        ? "VAT"
        : language == "فارسی"
            ? "مالیات"
            : language == "پشتو"
                ? "مالیات"
                : "VAT";
    String subtotalTitle = language == "English"
        ? "SUBTOTAL"
        : language == "فارسی"
            ? "مجموعه فرعی"
            : language == "پشتو"
                ? "مجموعه فرعی"
                : "SUBTOTAL";
    String discountTitle = language == "English"
        ? "DISCOUNT"
        : language == "فارسی"
            ? "تخفیف"
            : language == "پشتو"
                ? "تخفیف"
                : "DISCOUNT";
    String totalTitle = language == "English"
        ? "TOTAL"
        : language == "فارسی"
            ? "مجموعه"
            : language == "پشتو"
                ? "مجموعه"
                : "TOTAL";
    double calculateSubtotal() {
      double subtotal = 0.0;
      for (var item in items) {
        subtotal += item.quantity * item.amount;
      }
      return subtotal;
    }

    double calculateTotalVat() {
      double totalVat = 0.0;
      for (var item in items) {
        totalVat += (item.quantity * item.amount) * (item.tax / 100);
      }
      return totalVat;
    }

    double calculateDiscount() {
      double totalDiscount = 0.0;
      for (var item in items) {
        totalDiscount += (item.quantity * item.amount) * (item.discount / 100);
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
    final totalTax = calculateTotalVat();
    final discount = calculateDiscount();
    final total = calculateTotal();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Align(
          alignment: language == "English"
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 180,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextWidget(text: subtotalTitle, fontSize: 10),
                          Text(
                              "${subtotal.toStringAsFixed(2)} ${info.currency}",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal)),
                        ]),
                    SizedBox(height: 4),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextWidget(text: vatTitle, fontSize: 10),
                          Text(
                              "${totalTax.toStringAsFixed(2)} ${info.currency}",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal)),
                        ]),
                    SizedBox(height: 4),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextWidget(text: discountTitle, fontSize: 10),
                          Text(
                              "${discount.toStringAsFixed(2)} ${info.currency}",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal)),
                        ]),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        width: 180,
                        height: 1.5,
                        decoration: const BoxDecoration(
                          color: PdfColors.cyan,
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextWidget(text: totalTitle),
                          Text("${total.toStringAsFixed(2)} ${info.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: PdfColors.cyan)),
                        ]),
                  ]))),
    );
  }
}
