import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/AccountsCubit/AccountCategory/account_category_cubit.dart';

class AccountCategoryDropdown extends StatefulWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String title;
  final double radius;
  final Function(String) onSelected;
  final Function(int)? onSelectedId;

  const AccountCategoryDropdown({
    super.key,
    this.padding,
    this.margin,
    this.onSelectedId,
    this.radius = 3,
    this.width,
    this.title = "",
    required this.onSelected,
  });

  @override
  State<AccountCategoryDropdown> createState() => _AccountCategoryDropdownState();
}

class _AccountCategoryDropdownState extends State<AccountCategoryDropdown> {
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String? selectedCategory;
  int? selectedId;

  @override
  void initState() {
    super.initState();
    _loadDefaultValue();
  }

  void _loadDefaultValue() {
    final cubit = context.read<AccountCategoryCubit>();
    final state = cubit.state;

    if (state is LoadedAccountCategoryState && state.categories.isNotEmpty) {
      setState(() {
        selectedCategory = state.categories.first.accCategoryName;
      });
      widget.onSelected(selectedCategory!);
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
    final cubit = context.read<AccountCategoryCubit>();
    final state = cubit.state;

    if (state is! LoadedAccountCategoryState || state.categories.isEmpty) {
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
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: state.categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = category.accCategoryName);
                        setState(() => selectedId = category.accCategoryId);
                        widget.onSelected(selectedCategory!);
                        if (widget.onSelectedId != null) {
                          widget.onSelectedId!(selectedId!);
                        }
                        _overlayEntry.remove();
                        setState(() => _isOpen = false);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: selectedCategory == category.accCategoryName
                              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .5)
                              : Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.accCategoryName,
                              style: TextStyle(
                                color: selectedCategory == category.accCategoryName
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.check,
                              color: selectedCategory == category.accCategoryName
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

    return BlocBuilder<AccountCategoryCubit, AccountCategoryState>(
      builder: (context, state) {
        if (state is LoadedAccountCategoryState && state.categories.isNotEmpty && selectedCategory == null) {
          selectedCategory = state.categories.first.accCategoryName;
          widget.onSelected(selectedCategory!);
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
                      child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
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
                        Text(selectedCategory ?? "Category", style: TextStyle(color: color.surface, fontSize: 15)),
                        Icon(_isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: color.surface),
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
