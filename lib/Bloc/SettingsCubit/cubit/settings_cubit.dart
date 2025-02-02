import 'package:bloc/bloc.dart';

class SettingsCubit extends Cubit<Map<String, bool>> {
  SettingsCubit() : super({});

  // Toggle visibility of a UI element (e.g., tab or menu item) by its name
  void toggleVisibility(String key) {
    final updatedVisibility = Map<String, bool>.from(state);
    updatedVisibility[key] = !(updatedVisibility[key] ?? true);
    emit(updatedVisibility);
  }

  // Set visibility for specific keys
  void setVisibility(Map<String, bool> visibility) {
    emit(visibility);
  }
}
