import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaitoon_invoice/Components/Widgets/inventory_drop.dart';
import 'package:zaitoon_invoice/Components/Widgets/units_drop.dart';

class NumberInputField extends StatefulWidget {
  final String title;
  final Widget? below;
  final TextEditingController controller;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardInputType;
  final FocusNode? focusNode;
  final double width;
  final bool compactMode;
  final bool autoFocus;
  final List<TextInputFormatter>? inputFormat;

  const NumberInputField({
    super.key,
    required this.title,
    this.below,
    required this.controller,
    this.inputFormat,
    this.autoFocus = true,
    this.focusNode,
    this.compactMode = false,
    this.keyboardInputType,
    this.onChanged,
    this.validator,
    this.onSubmit,
    this.inputAction,
    this.width = 200,
  });

  @override
  NumberInputFieldState createState() => NumberInputFieldState();
}

class NumberInputFieldState extends State<NumberInputField> {
  void increment() {
    final currentValue = int.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = (currentValue + 1).toString();
  }

  void decrement() {
    final currentValue = int.tryParse(widget.controller.text) ?? 0;
    if (currentValue > 0) {
      widget.controller.text = (currentValue - 1).toString();
    }
  }

  String selectedUnit = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            inputFormatters:
            widget.inputFormat ?? [FilteringTextInputFormatter.digitsOnly],
            validator: widget.validator,
            onChanged: widget.onSubmit,
            focusNode: widget.focusNode,
            autofocus: widget.autoFocus,
            decoration: InputDecoration(
              isDense: widget.compactMode,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey.withAlpha(100)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey.withAlpha(100)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: theme.primary),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: theme.error),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: theme.error),
              ),
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13,
                color: Colors.grey,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InventoryDropdown(
                    width: 130,
                    radius: 3,
                    onSelected: (value) {
                      selectedUnit = value;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    width: 40, // Adjust width if needed
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Wraps content tightly
                      children: [
                        InkWell(
                          onTap: increment,
                          child: Icon(Icons.keyboard_arrow_up_rounded,
                              size: 20, color: theme.surface),
                        ),
                        InkWell(
                          onTap: decrement,
                          child: Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20, color: theme.surface),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
