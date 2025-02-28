import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldEntitled extends StatelessWidget {
  final String title;
  final String? hint;
  final bool isRequire;
  final bool isEnabled;
  final bool readOnly;
  final IconData? icon;
  final String info;
  final Widget? end;
  final bool securePassword;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final FormFieldValidator? validator;
  final TextInputType? keyboardInputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? trailing;
  final double width;
  final bool compactMode;
  final bool autoFocus;
  final List<TextInputFormatter>? inputFormat;

  const InputFieldEntitled({
    super.key,
    required this.title,
    this.hint,
    this.readOnly = false,
    this.info = "",
    this.autoFocus = true,
    this.compactMode = false,
    this.isEnabled = true,
    this.securePassword = false,
    this.end,
    this.focusNode,
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
                      readOnly: readOnly,
                      focusNode: focusNode,
                      autofocus: autoFocus,
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
                              BorderSide(color: Colors.grey.withAlpha(100)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(100)),
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
                        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
                        hintText: hint,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.grey),
                        isDense: compactMode,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                            vertical:
                                5.0), // Adjust this value to control the height
                      ),
                    ),
                  ),
                ],
              ),
            ),
            info.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text(info)],
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
