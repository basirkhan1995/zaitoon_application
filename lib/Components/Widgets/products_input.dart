import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductInputField extends StatefulWidget {
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

  const ProductInputField({
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
  State<ProductInputField> createState() => _ProductInputFieldState();
}

class _ProductInputFieldState extends State<ProductInputField> {

  String? errorMessage;

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
                          widget.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        widget.isRequire
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
                      readOnly: widget.readOnly,
                      focusNode: widget.focusNode,
                      autofocus: widget.autoFocus,
                      enabled: widget.isEnabled,
                      validator: (value) {
                        if (errorMessage != null) {
                          return errorMessage;
                        }
                        return widget.validator?.call(value);
                      },
                      onChanged: (value) {
                      setState(() {
                        widget.onChanged?.call(value);
                        validateProductName(value);
                      });
                      },
                      onFieldSubmitted: widget.onSubmit,
                      obscureText: widget.securePassword,
                      inputFormatters: widget.inputFormat,
                      keyboardType: widget.keyboardInputType,
                      controller: widget.controller,

                      decoration: InputDecoration(
                        suffixIcon: widget.trailing,
                        suffix: widget.end,
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
                        prefixIcon: widget.icon != null ? Icon(widget.icon, size: 18) : null,
                        hintText: widget.title,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.grey),
                        isDense: widget.compactMode,
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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red.shade900,fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void validateProductName(String value) async {
    if (value.isEmpty) {
      setState(() {
        errorMessage = null; // No error for empty input
      });
      return;
    }

    bool exists = await Repositories.checkIfProductExists(value);
    if(exists) {
      await Future.delayed(Duration(seconds: 1));
    }
    setState(() {
      errorMessage = exists ? AppLocalizations.of(context)!.duplicateProductMessage : null;
    });
  }
}




