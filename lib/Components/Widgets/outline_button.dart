import 'package:flutter/material.dart';

class ZOutlineButton extends StatefulWidget {
  final Widget label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? backgroundHover;
  final Color? foregroundHover;
  final Color? textColor;
  final IconData? icon;

  const ZOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundHover,
    this.foregroundHover,
    this.textColor,
    this.width = 155,
    this.icon,
    this.backgroundColor,
    this.height = 60,
  });

  @override
  ZOutlineButtonState createState() => ZOutlineButtonState();
}

class ZOutlineButtonState extends State<ZOutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: OutlinedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            ),
            backgroundColor: WidgetStateProperty.all(
              _isHovered
                  ? widget.backgroundHover ?? theme.colorScheme.primary
                  : widget.backgroundColor ?? Colors.transparent,
            ),
            side: WidgetStateProperty.all(
              BorderSide(
                color: _isHovered
                    ? widget.backgroundHover ?? theme.colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ),
          onPressed: widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with hover logic
              widget.icon == null
                  ? const SizedBox()
                  : Icon(
                      widget.icon,
                      color: _isHovered
                          ? widget.foregroundHover ??
                              theme.colorScheme.onPrimary
                          : widget.textColor ?? Colors.grey,
                    ),
              widget.icon == null ? const SizedBox() : const SizedBox(width: 5),
              // Label text with hover logic
              DefaultTextStyle.merge(
                style: TextStyle(
                  color: _isHovered
                      ? widget.foregroundHover ?? theme.colorScheme.onPrimary
                      : widget.textColor ?? Colors.grey,
                ),
                child: widget.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
