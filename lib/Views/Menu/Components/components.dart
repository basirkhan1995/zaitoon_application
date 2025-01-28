import 'package:flutter/material.dart';

class MenuComponents {
  final String title;
  final IconData icon;
  final Widget screen;
  final String? userRole;
  MenuComponents(
      {required this.icon,
      required this.title,
      required this.screen,
      this.userRole});
}
