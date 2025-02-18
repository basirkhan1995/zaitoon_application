import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfPrintSetting extends StatefulWidget {
  const PdfPrintSetting({super.key});

  @override
  State<PdfPrintSetting> createState() => _PdfPrintSettingState();
}

class _PdfPrintSettingState extends State<PdfPrintSetting> {
  List<Printer> _printers = [];
  Printer? _selectedPrinter;

  @override
  void initState() {
    super.initState();
    _loadPrinters();
  }

  // Fetch the list of available printers
  Future<void> _loadPrinters() async {
    final printers =
        await Printing.listPrinters(); // This gets available printers
    setState(() {
      _printers = printers;
      _selectedPrinter = printers.isNotEmpty ? printers.first : null;
    });
  }

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
            Padding(
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
      width: 200,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<Printer>(
            value: _selectedPrinter,
            hint: Text('Select Printer'),
            onChanged: (Printer? newPrinter) {
              setState(() {
                _selectedPrinter = newPrinter;
              });
            },
            items: _printers.map<DropdownMenuItem<Printer>>((Printer printer) {
              return DropdownMenuItem<Printer>(
                value: printer,
                child: Text(printer.name),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
