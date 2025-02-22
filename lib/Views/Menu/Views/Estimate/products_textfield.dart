import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';

class ProductTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FocusNode? focusNode;
  final Widget? trailing;
  final Widget? end;
  final bool isRequire;
  final FormFieldValidator? validator;
  final ValueChanged<int>? onChanged;

  const ProductTextField({
    super.key,
    this.controller,
    this.hintText,
    this.focusNode,
    this.end,
    this.trailing,
    this.isRequire = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<ProductTextField> createState() => _ProductTextFieldState();
}

class _ProductTextFieldState extends State<ProductTextField> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _fieldKey = GlobalKey();
  List<String> _currentSuggestions = []; // Store the current suggestions
  String? _selectedItemName;
  int? _selectedItemId;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange); // Remove listener
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay(BuildContext context) {
    _removeOverlay();

    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 1,
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductSearchingError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.error.toString(),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                );
              }
              if (state is LoadedProductsState) {
                _currentSuggestions = state.products
                    .map((e) => e.productName.toString())
                    .toList();
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedItemName = state.products[index].productName;
                          _selectedItemId = state.products[index].productId;
                        });
                        widget.controller?.text = _selectedItemName ??
                            ""; // Assign itemId to controller
                        widget.onChanged?.call(_selectedItemId!);
                        _removeOverlay();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.products[index].productName!),
                      ),
                    );
                  },
                );
              }
              if (state is ProductsErrorState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.error),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  String? _customValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!
          .required(AppLocalizations.of(context)!.products);
    }
    if (!_currentSuggestions.contains(value)) {
      return "The Item not found";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      key: _fieldKey,
      controller: widget.controller,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context.read<ProductsCubit>().productSearchingEvent(keyword: value);
          _showOverlay(context);
        } else {
          context.read<ProductsCubit>().resetProductsEvent();
          _removeOverlay();
        }

        // If the value is not in the suggestions, clear the selection
        if (!_currentSuggestions.contains(value)) {
          setState(() {
            _selectedItemName = null;
            _selectedItemId = null;
            context.read<ProductsCubit>().resetProductsEvent();
          });
        }
      },
      validator: widget.validator ?? _customValidator, // Use custom validator
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        suffixIcon: widget.trailing,
        suffix: widget.end,
        suffixIconConstraints: const BoxConstraints(),
        hintText: widget.hintText,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1.5, color: Theme.of(context).colorScheme.primary)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
    );
  }
}
