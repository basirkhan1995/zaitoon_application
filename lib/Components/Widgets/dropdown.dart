import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';

class SelectLanguage extends StatefulWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const SelectLanguage({
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
  });

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey(); // Key for the button

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'icon': Icons.translate},
    {'code': 'fa', 'name': 'فارسی', 'icon': Icons.translate},
    {'code': 'ar', 'name': 'پشتو', 'icon': Icons.translate},
  ];

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LanguageCubit>();
    final currentLanguage = localeCubit.state.languageCode;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        if (_isOpen) {
          _overlayEntry.remove();
        } else {
          _overlayEntry = _createOverlayEntry(context);
          Overlay.of(context).insert(_overlayEntry);
        }
        setState(() {
          _isOpen = !_isOpen;
        });
      },
      child: Container(
        key: _buttonKey, // Attach key to this container
        width: widget.width ?? double.infinity,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Dropdown Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _languages.firstWhere((lang) => lang['code'] == currentLanguage)['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creates the overlay entry
  OverlayEntry _createOverlayEntry(BuildContext context) {
    final localeCubit = context.read<LanguageCubit>();
    final currentLanguage = localeCubit.state.languageCode;

    // Get the position and size of the button using the global key
    RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double buttonWidth = renderBox.size.width; // Get width of the button

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx, // Align it exactly with the button's left edge
        top: offset.dy + renderBox.size.height + 8, // Add extra space between header and dropdown
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: buttonWidth, // Set the overlay width to match the button's width exactly
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: currentLanguage == lang['code']
                          ? Colors.blueAccent.withValues(alpha: .1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          lang['icon'],
                          color: currentLanguage == lang['code']
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          lang['name'],
                          style: TextStyle(
                            color: currentLanguage == lang['code']
                                ? Colors.blueAccent
                                : Colors.black87,
                            fontSize: 16,
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
    );
  }
}
