import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  const AppBackground(
      {super.key,
      this.width,
      required this.child,
      this.padding,
      this.margin,
      this.borderRadius = 5});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      margin: margin ?? const EdgeInsets.all(10),
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 0,
              color: Colors.grey.withValues(alpha: .3))
        ],
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }
}
