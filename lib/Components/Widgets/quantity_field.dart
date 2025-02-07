import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/Inventory/inventory_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/units_drop.dart';

class QuantityInputField extends StatefulWidget {
  final String title;
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

  const QuantityInputField({
    super.key,
    required this.title,
    required this.controller,
    this.autoFocus = true,
    this.focusNode,
    this.compactMode = false,
    this.keyboardInputType,
    this.onChanged,
    this.validator,
    this.onSubmit,
    this.inputAction,
    this.width = 200,
    this.inputFormat,
  });

  @override
  QuantityInputFieldState createState() => QuantityInputFieldState();
}

class QuantityInputFieldState extends State<QuantityInputField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String? selectedStock;
  bool isOverlayOpen = false;
  String selectedValue = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<InventoryCubit>().state;
      if (state is LoadedInventoryState && state.inventories.isNotEmpty) {
        setState(() {
          selectedStock = state.inventories.first.inventoryName;
        });
      }
    });
  }

  void _toggleOverlay() {
    if (isOverlayOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (isOverlayOpen) return; // Prevent duplicate overlays

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.6,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 50), // Position below the container
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(5),
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state is LoadedInventoryState && state.inventories.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.inventories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.inventories[index].inventoryName),
                        selected: state.inventories[index].inventoryName == selectedStock,
                        onTap: () {
                          setState(() {
                            selectedStock = state.inventories[index].inventoryName;
                          });
                          _removeOverlay();
                        },
                      );
                    },
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("No inventory available")),
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    isOverlayOpen = true;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    isOverlayOpen = false;
  }

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
          CompositedTransformTarget(
            link: _layerLink,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // TextField
                TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: widget.inputFormat ?? [FilteringTextInputFormatter.digitsOnly],
                  validator: widget.validator,
                  onChanged: widget.onSubmit,
                  focusNode: widget.focusNode,
                  autofocus: widget.autoFocus,
                  decoration: InputDecoration(
                    isDense: widget.compactMode,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.grey),
                    suffixIcon: Container(
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(3)),
                      width: 40,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              int currentValue = int.tryParse(widget.controller.text) ?? 0;
                              widget.controller.text = (currentValue + 1).toString();
                            },
                            child: Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: theme.surface),
                          ),
                          InkWell(
                            onTap: () {
                              int currentValue = int.tryParse(widget.controller.text) ?? 0;
                              if (currentValue > 0) {
                                widget.controller.text = (currentValue - 1).toString();
                              }
                            },
                            child: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: theme.surface),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Stock Selection Container (Clickable)
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _toggleOverlay,
                    child: ProductUnitDropdown(
                      width: 100,
                      onSelected: (unit) {
                        selectedValue = unit;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
