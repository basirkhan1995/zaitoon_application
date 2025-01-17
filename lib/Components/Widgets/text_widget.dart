
import 'package:flutter/material.dart';

class ZText extends StatelessWidget {
  final String text;

  const ZText(this.text, {super.key});

  bool isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF]');
    return persianRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final parts = text.split(RegExp(r'(?<=\s)')); // Split by spaces

    return Text.rich(
      TextSpan(
        children: parts.map((part) {
          return TextSpan(
            text: part,
            style: TextStyle(
              fontFamily: isPersian(part) ? 'Amir' : 'Roboto',
              fontSize: 16,
            ),
          );
        }).toList(),
      ),
      textDirection: TextDirection.rtl, // Adjust based on primary language
    );
  }
}
