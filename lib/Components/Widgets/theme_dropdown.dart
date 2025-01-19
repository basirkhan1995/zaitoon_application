import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ThemeCubit/theme_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppTheme extends StatefulWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;

  const AppTheme({
    super.key,
    this.padding,
    this.margin,
    this.radius = 4,
    this.width,
  });

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey(); // Key for the button
  final FocusNode _focusNode = FocusNode();

  // Define available theme modes (without hardcoded names)
  final List<Map<String, dynamic>> _themeModes = [
    {'mode': 'system', 'icon': Icons.settings},
    {'mode': 'light', 'icon': Icons.light_mode},
    {'mode': 'dark', 'icon': Icons.dark_mode},
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final currentTheme = themeCubit.state; // Get current theme mode
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
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 0),
          margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 0),
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
                      _themeModes.firstWhere(
                                  (theme) =>
                                      theme['mode'] ==
                                      currentTheme.name.toLowerCase(),
                                  orElse: () => _themeModes[0])['mode'] ==
                              'system'
                          ? AppLocalizations.of(context)!.systemTheme
                          : _themeModes.firstWhere((theme) =>
                                      theme['mode'] ==
                                      currentTheme.name
                                          .toLowerCase())['mode'] ==
                                  'light'
                              ? AppLocalizations.of(context)!.lightTheme
                              : AppLocalizations.of(context)!.darkTheme,
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
      ),
    );
  }

  // Creates the overlay entry
  OverlayEntry _createOverlayEntry(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final selectedTheme =
        themeCubit.state.name.toLowerCase(); // Get the selected theme name

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
                  children: _themeModes.map((theme) {
                    bool isSelected = theme['mode'] ==
                        selectedTheme; // Check if this is the selected theme

                    return GestureDetector(
                      onTap: () {
                        themeCubit
                            .onThemeChanged(theme['mode']); // Change theme
                        _overlayEntry.remove();
                        setState(() {
                          _isOpen = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blueAccent.withValues(
                                  alpha: .1) // Selected theme background
                              : Colors
                                  .transparent, // Transparent for unselected themes
                        ),
                        child: Row(
                          children: [
                            Icon(
                              theme['icon'],
                              size: 18,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              theme['mode'] == 'system'
                                  ? AppLocalizations.of(context)!.systemTheme
                                  : theme['mode'] == 'light'
                                      ? AppLocalizations.of(context)!.lightTheme
                                      : AppLocalizations.of(context)!.darkTheme,
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface, // Change text color based on selection
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
