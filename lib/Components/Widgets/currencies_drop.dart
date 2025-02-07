import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/CurrencyCubit/Currency/currency_cubit.dart';

class CurrenciesDropdown extends StatefulWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String title;
  final double radius;
  final Function(String) onSelected;

  const CurrenciesDropdown({
    super.key,
    this.padding,
    this.margin,
    this.radius = 4,
    this.width,
    this.title = "",
    required this.onSelected,
  });

  @override
  State<CurrenciesDropdown> createState() => _CurrenciesDropdownState();
}

class _CurrenciesDropdownState extends State<CurrenciesDropdown> {
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _loadDefaultValue();
  }

  void _loadDefaultValue() {
    final cubit = context.read<CurrencyCubit>();
    final state = cubit.state;

    if (state is LoadedCurrencyState && state.currencies.isNotEmpty) {
      setState(() {
        selectedValue = state.currencies.first.currencyCode;
      });
      widget.onSelected(selectedValue!);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown(BuildContext context) {
    if (_isOpen) {
      _overlayEntry.remove();
    } else {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry);
    }
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final cubit = context.read<CurrencyCubit>();
    final state = cubit.state;

    if (state is! LoadedCurrencyState || state.currencies.isEmpty) {
      return OverlayEntry(builder: (_) => SizedBox());
    }

    RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double buttonWidth = renderBox.size.width;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry.remove();
              setState(() => _isOpen = false);
            },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + renderBox.size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: buttonWidth,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(widget.radius),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: state.currencies.map((unit) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedValue = unit.currencyCode);
                        widget.onSelected(selectedValue!);
                        _overlayEntry.remove();
                        setState(() => _isOpen = false);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: selectedValue == unit.currencyCode
                              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .5)
                              : Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              unit.currencyCode,
                              style: TextStyle(
                                color: selectedValue == unit.currencyCode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.check,
                              color: selectedValue == unit.currencyCode
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              size: 18,
                            ),

                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        if (state is LoadedCurrencyState && state.currencies.isNotEmpty && selectedValue == null) {
          selectedValue = state.currencies.first.currencyCode;
          widget.onSelected(selectedValue!);
        }
        return Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            if (!hasFocus && _isOpen) {
              _overlayEntry.remove();
              setState(() => _isOpen = false);
            }
          },
          child: GestureDetector(
            onTap: () => _toggleDropdown(context),
            child: Container(
              key: _buttonKey,
              width: widget.width ?? double.infinity,
              padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 0),
              margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedValue ?? "Currency",
                          style: TextStyle(color: color.surface, fontSize: 13),
                        ),
                        Icon(
                            _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: Theme.of(context).colorScheme.surface
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
