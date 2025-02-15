// import 'dart:io';
// import 'package:file_selector/file_selector.dart';
// import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class PdfInvoice {
//   Future<void> pdf() async {
//     // Create a new PDF document.
//     final PdfDocument document = PdfDocument();
// // Add a PDF page and draw text.
//     document.pages.add().graphics.drawString(
//         'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         bounds: const Rect.fromLTWH(0, 0, 150, 20));
// // Save the document.
//     await saveDocument(suggestedName: 'newInvoice.pdf', pdf: document);
// // Dispose the document.
//     document.dispose();
//   }

//   static Future<File?> saveDocument({
//     required String suggestedName,
//     required PdfDocument pdf,
//   }) async {
//     try {
//       // Open the native Save File dialog
//       final FileSaveLocation? fileSaveLocation = await getSaveLocation(
//         suggestedName: suggestedName, // Default file name
//         acceptedTypeGroups: [
//           const XTypeGroup(
//             label: 'PDF Files', // Label for file types
//             extensions: ['pdf'], // Limit to .pdf files
//           ),
//         ],
//       );

//       // If the user cancels the dialog, fileSaveLocation will be null
//       if (fileSaveLocation == null) {
//         return null;
//       }

//       // Ensure the file path has a .pdf extension
//       String filePath = fileSaveLocation.path;
//       if (!filePath.toLowerCase().endsWith('.pdf')) {
//         filePath += '.pdf'; // Append .pdf extension if missing
//       }

//       // Save the PDF document to the selected path
//       final bytes = await pdf.save();

//       // Write the bytes to the file
//       final file = File(filePath);
//       await file.writeAsBytes(bytes);
//       return file; // Return the saved file
//     } catch (e) {
//       return null;
//     }
//   }
// }
