import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final IconData? icon;
  final double width;
  final Widget? trailing;
  final bool underLineBorder;

  final ValueChanged<String>? onSubmit;
  final bool enabledBorder;

  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.width = 300,
    this.underLineBorder = false,
    this.icon,
    this.onChanged,
    this.trailing,
    this.onSubmit,
    this.padding,
    this.margin,
    this.enabledBorder = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(5), // Rounded corners for a smooth feel
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            spreadRadius: 1,
            color: Colors.grey.withOpacity(0.2), // Soft shadow effect
          ),
        ],
      ),
      width: width,
      height: 40, // Increased height for better padding and visual balance
      padding: padding ?? const EdgeInsets.symmetric(vertical: 0),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmit,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600, // Lighter color for hint text
          ),
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context)
                .iconTheme
                .color
                ?.withOpacity(0.7), // Slightly transparent icon color
          ),
          suffixIcon: trailing,
          border: InputBorder.none,
          disabledBorder: underLineBorder
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                )
              : null,
          enabledBorder: underLineBorder
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
              vertical: 15.0), // Extra padding for better touch targets
        ),
      ),
    );
  }
}
