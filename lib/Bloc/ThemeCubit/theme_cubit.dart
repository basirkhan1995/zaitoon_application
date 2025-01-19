import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  // Load saved theme mode from SharedPreferences
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('themeMode');
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          emit(ThemeMode.light);
          break;
        case 'dark':
          emit(ThemeMode.dark);
          break;
        case 'system':
        default:
          emit(ThemeMode.system);
          break;
      }
    }
  }

  // Method to change the theme and save it to SharedPreferences
  Future<void> onThemeChanged(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    // Save the selected theme mode to SharedPreferences
    prefs.setString('themeMode', mode);

    switch (mode) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'system':
      default:
        emit(ThemeMode.system);
        break;
    }
  }
}
