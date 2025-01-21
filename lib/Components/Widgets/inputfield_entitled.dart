import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldEntitled extends StatelessWidget {
  final String title;
  final String? hint;
  final bool isRequire;
  final bool isEnabled;
  final IconData? icon;
  final Widget? end;
  final bool securePassword;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final FormFieldValidator? validator;
  final TextInputType? keyboardInputType;
  final TextEditingController? controller;
  final Widget? trailing;
  final double width;
  final List<TextInputFormatter>? inputFormat;

  const InputFieldEntitled({
    super.key,
    required this.title,
    this.hint,
    this.isEnabled = true,
    this.securePassword = false,
    this.end,
    this.isRequire = false,
    this.icon,
    this.inputFormat,
    this.validator,
    this.onSubmit,
    this.controller,
    this.onChanged,
    this.width = .5,
    this.trailing,
    this.keyboardInputType,
    this.inputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        isRequire
                            ? Text(
                                " *",
                                style: TextStyle(color: Colors.red.shade900),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      enabled: isEnabled,
                      validator: validator,
                      onChanged: onChanged,
                      onFieldSubmitted: onSubmit,
                      obscureText: securePassword,
                      inputFormatters: inputFormat,
                      keyboardType: keyboardInputType,
                      controller: controller,
                      decoration: InputDecoration(
                        suffixIcon: trailing,
                        suffix: end,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        prefixIcon: Icon(icon, size: 18),
                        hintText: title,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.grey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical:
                                5.0), // Adjust this value to control the height
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
