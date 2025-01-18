import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // Method to change the theme
  void onThemeChanged(String mode) {
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
