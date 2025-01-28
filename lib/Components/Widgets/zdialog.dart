import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';

class ZAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onYes;
  final IconData? icon;

  const ZAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYes,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width: 380,
        decoration: BoxDecoration(
          color: theme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: theme.primary),
                    const SizedBox(width: 8), // Adds spacing between the icon and title
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ZOutlineButton(
                        height: 40,
                        width: 100,
                        onPressed: onYes,
                        label: Text(AppLocalizations.of(context)!.yes),
                      ),
                      const SizedBox(width: 7),
                      ZOutlineButton(
                        height: 40,
                        width: 100,
                        backgroundHover: theme.error,
                        onPressed: ()=>  Navigator.of(context).pop(),
                        label: Text(AppLocalizations.of(context)!.ignore),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
