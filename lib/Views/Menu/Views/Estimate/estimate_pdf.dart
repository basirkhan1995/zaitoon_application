import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_selector/file_selector.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bidi/bidi.dart' as bidi;


class InvoiceComponents {
  final AppLocalizations localizations;
  InvoiceComponents({required this.localizations});

  String? directoryPath;

  static String formatBidiText(String input) {
    // Manually add RTL control characters
    return '\u202B$input\u202C';
  }
   Future<void> generateInvoice({
    required List<EstimateItemsModel> invoiceItems,
    required List<String> headerTitles,
    required EstimateInfoModel invoiceInfo,
    required String appLanguage,
    required String supplierTitle,
    required String customerTitle,
    required String subtotalTitle,
    required String vatTitle,
    required String discountTitle,
    required String totalTitle,
    required String termsAndConditionTitle,
  }) async {
    final englishFontData =
        await rootBundle.load('assets/fonts/NotoSans/NotoSans-Regular.ttf');
    final persianFontData = await rootBundle.load('assets/fonts/Amiri/Amiri-Regular.ttf');
    final persianFont = Font.ttf(persianFontData);
    final englishFont = Font.ttf(englishFontData);


    // Determine language settings
    final isEnglish = appLanguage == 'en';
    final font = isEnglish ? englishFont : persianFont;
    final textDirection = isEnglish ? TextDirection.ltr : TextDirection.rtl;

    var myTheme = ThemeData.withFont(
      fontFallback: [englishFont, persianFont],
      base: Font.ttf(
          await rootBundle.load("assets/fonts/OpenSans/OpenSans-Regular.ttf")),
      bold: Font.ttf(
          await rootBundle.load("assets/fonts/Amiri/Amiri-Regular.ttf")),
      italic: Font.ttf(
          await rootBundle.load("assets/fonts/Roboto/Roboto-Regular.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("assets/fonts/NotoSans/NotoSans-Regular.ttf")),
    );

    final bodyTextStyle =
        TextStyle(font: font, fontFallback: [persianFont, englishFont]);

    final titleTextStyle = TextStyle(
        font: font,
        color: PdfColors.cyan,
        fontWeight: FontWeight.bold,
        fontFallback: [persianFont, englishFont]);
    final pdf = Document(theme: myTheme);

    pdf.addPage(MultiPage(
      textDirection:
          appLanguage == "en" ? TextDirection.ltr : TextDirection.rtl,
      margin: EdgeInsets.zero,
      build: (context) => [
        buildTitleHeader(
            invoiceInfo: invoiceInfo,
            textStyle: bodyTextStyle,
            textDirection: textDirection,
            customerTitleText: customerTitle,
            supplierTitleText: supplierTitle),
        SizedBox(height: 5),
        buildTableHeader(
            invoiceItems: invoiceItems,
            headerTitles: headerTitles,
            fontTheme: bodyTextStyle,
            isEnglish: isEnglish),
        SizedBox(height: 5),
        buildTotal(
            invoiceItems: invoiceItems,
            invoice: invoiceInfo,
            textStyle: bodyTextStyle,
            appLanguage: appLanguage,
            subtotalTitle: subtotalTitle,
            vatTitle: vatTitle,
            discountTitle: discountTitle,
            totalTitle: totalTitle),
        SizedBox(height: 5),
        buildAgreementNote(
            info: invoiceInfo,
            textStyle: bodyTextStyle,
            titleTextStyle: titleTextStyle,
            termsAndConditionTitle: termsAndConditionTitle),
      ],
      header: (context) => buildTopHeader(invoiceInfo: invoiceInfo,locale: localizations,persianFont: persianFont),
      footer: (context) =>
          buildFooter(info: invoiceInfo, font: font, direction: textDirection),
    ));

    //Save PDF Document
    await saveDocument(suggestedName: "Invoice.pdf", pdf: pdf);
  }

  static Widget buildAgreementNote(
      {required EstimateInfoModel info,
      required String termsAndConditionTitle,
      required TextStyle textStyle,
      required TextStyle titleTextStyle}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(termsAndConditionTitle, style: titleTextStyle),
              Text(info.termsAndCondition, style: textStyle)
              // Text("In Flutter, the DateTime object is a fundamental data type used to represent a specific point in time, accurate In Flutter, the DateTime object is a fundamental data type used to represent a specific point in time, accurate.")
            ]));
  }

  static Widget buildTopHeader({required EstimateInfoModel invoiceInfo, required AppLocalizations locale, required Font persianFont}) {
    final image = invoiceInfo.logo != null && invoiceInfo.logo!.isNotEmpty
        ? MemoryImage(invoiceInfo.logo!)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Beginning
          Column(
            children: [
              Row(children: [
                image == null
                    ? Text(
                    '\u202B${invoiceInfo.supplier}\u202C',
                        style: TextStyle(font: persianFont)
                      )
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
                              Text(invoiceInfo.supplier,style: TextStyle(font: persianFont)),
                              Text(invoiceInfo.supplierMobile,
                                  style: const TextStyle(fontSize: 10)),
                              Text(invoiceInfo.supplierEmail,
                                  style: const TextStyle(fontSize: 10)),
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
                  Text(locale.invoiceDate,
                      style: const TextStyle(color: PdfColors.grey)),
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
                  Text(locale.invoiceNumber,
                      style: const TextStyle(color: PdfColors.grey)),
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

  static Widget buildTitleHeader(
      {required EstimateInfoModel invoiceInfo,
      required TextStyle textStyle,
      required TextDirection textDirection,
      required String supplierTitleText,
      required String customerTitleText}) {
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
                        style: textStyle, textDirection: textDirection),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplier, style: textStyle),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplierEmail, style: textStyle),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplierMobile, style: textStyle),
                  ]),

              //To
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(customerTitleText,
                        style: textStyle, textDirection: textDirection),
                    SizedBox(height: 3),
                    buildText(invoiceInfo.clientName, textStyle),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplierMobile, style: textStyle),
                    SizedBox(height: 3),
                    Text(invoiceInfo.supplierEmail, style: textStyle),
                  ])
            ]));
  }

  static Widget buildTableHeader1(
      {required List<EstimateItemsModel> invoiceItems,
      required List<String> headerTitles}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(children: [
        TableHelper.fromTextArray(
            headerAlignment: Alignment.centerLeft,
            cellAlignment: Alignment.centerLeft,
            oddRowDecoration: const BoxDecoration(color: PdfColors.cyan50),
            border: null,
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PdfColors.cyan, // Set your preferred color here
                  width: 1.7, // Set your preferred width here
                ),
              ),
            ),
            headerHeight: 35,
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerLeft,
              2: Alignment.center,
              3: Alignment.center,
              4: Alignment.center,
              5: Alignment.center,
              6: Alignment.centerRight,
            },
            headers: headerTitles,
            data: invoiceItems.map((e) {
              return [
                e.rowNumber,
                e.itemName,
                e.quantity,
                e.amount,
                e.tax,
                e.discount,
                e.total,
              ];
            }).toList()),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            height: 1.7,
            width: double.infinity,
            decoration: const BoxDecoration(color: PdfColors.cyan))
      ]),
    );
  }

  static Widget buildTableHeader({
    required List<EstimateItemsModel> invoiceItems,
    required List<String> headerTitles,
    required TextStyle fontTheme,
    required bool isEnglish,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          TableHelper.fromTextArray(
            cellStyle: fontTheme,
            headerStyle: fontTheme.copyWith(
              fontWeight: pw.FontWeight.bold,
            ),
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
            columnWidths: isEnglish
                ? {
                    0: const pw.FixedColumnWidth(30),
                    1: const pw.FlexColumnWidth(10),
                    2: const pw.FixedColumnWidth(50),
                    3: const pw.FixedColumnWidth(70),
                    4: const pw.FixedColumnWidth(50),
                    5: const pw.FixedColumnWidth(65),
                    6: const pw.FixedColumnWidth(70),
                  }
                : {
                    6: const pw.FixedColumnWidth(30),
                    5: const pw.FlexColumnWidth(10),
                    4: const pw.FixedColumnWidth(50),
                    3: const pw.FixedColumnWidth(70),
                    2: const pw.FixedColumnWidth(50),
                    1: const pw.FixedColumnWidth(65),
                    0: const pw.FixedColumnWidth(70),
                  },
            cellAlignments: isEnglish
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
            headers: isEnglish ? headerTitles : headerTitles.reversed.toList(),
            data: invoiceItems.map((e) {
              final row = [
                e.rowNumber,
                e.itemName,
                e.quantity,
                e.amount,
                e.tax,
                e.discount,
                e.total,
              ];
              return isEnglish ? row : row.reversed.toList();
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

  static Widget buildFooter(
          {required EstimateInfoModel info,
          required Font font,
          required TextDirection direction}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text(info.supplierEmail,
              style: TextStyle(font: font), textDirection: direction),
          verticalDividerWidget(width: 1, height: 15),
          Text(info.supplierMobile,
              style: TextStyle(font: font), textDirection: direction),
          verticalDividerWidget(width: 1, height: 15),
          Text(info.supplierAddress,
              style: TextStyle(font: font), textDirection: direction),
        ]),
      );

  static Widget buildTotal(
      {required List<EstimateItemsModel> invoiceItems,
      required EstimateInfoModel invoice,
      required TextStyle textStyle,
      required String appLanguage,
      required String subtotalTitle,
      required String vatTitle,
      required String discountTitle,
      required String totalTitle}) {
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
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
          alignment: appLanguage == "en"
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
                          Text(subtotalTitle, style: textStyle),
                          Text(
                              "${subtotal.toStringAsFixed(2)} ${invoice.currency}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vatTitle, style: textStyle),
                          Text(
                              "${totalTax.toStringAsFixed(2)} ${invoice.currency}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(discountTitle, style: textStyle),
                          Text(
                              "${discount.toStringAsFixed(2)} ${invoice.currency}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                    Container(
                        width: 180,
                        height: 1.7,
                        decoration: const BoxDecoration(
                          color: PdfColors.cyan,
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(totalTitle, style: textStyle),
                          Text(
                              "${total.toStringAsFixed(2)} ${invoice.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: PdfColors.cyan)),
                        ]),
                  ]))),
    );
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

  static Widget verticalDividerWidget(
      {required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      color: PdfColors.grey300, // Divider color
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    );
  }

  static bool isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return persianRegex.hasMatch(text);
  }

  static Widget buildText(String text, TextStyle fontStyle) {
    final isRtl = isPersian(text);
    return Text(
      text,
      style: fontStyle,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
    );
  }
}
