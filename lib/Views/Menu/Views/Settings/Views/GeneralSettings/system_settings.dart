import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Components/Widgets/language_dropdown.dart';
import 'package:zaitoon_invoice/Components/Widgets/theme_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemSettingsView extends StatelessWidget {
  const SystemSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [

       AppLanguage(
        margin: EdgeInsets.symmetric(vertical: 0),
        width: 280,
        title: localizations.language,
       ),
       AppTheme(
         title: localizations.theme,
         margin: EdgeInsets.symmetric(vertical: 0),
         width: 280,
       ),

      ],
    );
  }
}
