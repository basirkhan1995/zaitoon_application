import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';

class SelectLanguage extends StatefulWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;

  const SelectLanguage({
    super.key,
    this.padding,
    this.margin,
    this.radius = 4,
    this.width,
  });

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey(); // Key for the button
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'icon': Icons.translate},
    {'code': 'fa', 'name': 'فارسی', 'icon': Icons.translate},
    {'code': 'ar', 'name': 'پشتو', 'icon': Icons.translate},
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LanguageCubit>();
    final currentLanguage = localeCubit.state.languageCode;
    final color = Theme.of(context).colorScheme;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: (hasFocus) {
        if (!hasFocus && _isOpen) {
          _overlayEntry.remove();
          setState(() {
            _isOpen = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
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
        },
        child: Container(
          key: _buttonKey, // Attach key to this container
          width: widget.width ?? double.infinity,
          padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 0),
          margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Dropdown Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: color.primary,
                  borderRadius: BorderRadius.circular(widget.radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _languages.firstWhere(
                          (lang) => lang['code'] == currentLanguage)['name'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Creates the overlay entry
  OverlayEntry _createOverlayEntry(BuildContext context) {
    final localeCubit = context.read<LanguageCubit>();
    final currentLanguage = localeCubit.state.languageCode;

    // Get the position and size of the button using the global key
    RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double buttonWidth = renderBox.size.width; // Get width of the button

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // A GestureDetector as a barrier to detect taps outside the dropdown
          GestureDetector(
            onTap: () {
              _overlayEntry.remove();
              setState(() {
                _isOpen = false;
              });
            },
            child: Container(
              color: Colors.transparent, // Makes it transparent and tappable
            ),
          ),
          Positioned(
            left: offset.dx, // Align it exactly with the button's left edge
            top: offset.dy + renderBox.size.height + 8, // Position below button
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: buttonWidth, // Match the button's width
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: _languages.map((lang) {
                    return GestureDetector(
                      onTap: () {
                        localeCubit.changeLocale(Locale(lang['code']));
                        _overlayEntry.remove();
                        setState(() {
                          _isOpen = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: currentLanguage == lang['code']
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withValues(alpha: .5)
                                : Theme.of(context).colorScheme.surface),
                        child: Row(
                          children: [
                            Icon(
                              lang['icon'],
                              color: currentLanguage == lang['code']
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              lang['name'],
                              style: TextStyle(
                                color: currentLanguage == lang['code']
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
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
}
