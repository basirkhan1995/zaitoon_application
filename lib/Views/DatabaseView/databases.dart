import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Widgets/dropdown.dart';

class LoadAllDatabases extends StatelessWidget {
  const LoadAllDatabases({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.databases),
        actions: [
          SelectLanguage(
            width: 250,
          ),
        ],
      ),
     body: Center(
       child: Column(
         children: [
           SelectLanguage(
             width: 250,
           ),
         ],
       ),
     ),
    );
  }
}
