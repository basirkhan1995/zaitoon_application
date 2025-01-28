import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color? color;
  const Button({super.key,
    required this.label,
    required this.onPressed,
    this.width = 80,
    this.color,
    this.height = 60
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
              backgroundColor: WidgetStateProperty.all(color ?? Theme.of(context).colorScheme.primary),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface)
          ),

          onPressed: onPressed,
          child: label),
    );
  }
}
