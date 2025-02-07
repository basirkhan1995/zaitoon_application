import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(SelectedState(index: 0, visibleItems: {})) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final visibleItems = <int, bool>{
      0: prefs.getBool('menu_item_0') ?? true,  // Dashboard
      1: prefs.getBool('menu_item_1') ?? true,  // Invoice
      2: prefs.getBool('menu_item_2') ?? false, // Estimate (default false)
      3: prefs.getBool('menu_item_3') ?? true,  // Accounts
      4: prefs.getBool('menu_item_4') ?? false, // Transport (default false)
      5: prefs.getBool('menu_item_5') ?? true,  // Products
      6: prefs.getBool('menu_item_6') ?? true,  // Reports
    };

    emit(SelectedState(index: 0, visibleItems: visibleItems));
  }


  Future<void> _saveState(Map<int, bool> visibleItems) async {
    final prefs = await SharedPreferences.getInstance();

    // Save visibility state for each menu item
    for (var entry in visibleItems.entries) {
      await prefs.setBool('menu_item_${entry.key}', entry.value);
    }
  }

  void onChangedEvent({required int index}) {
    final currentState = state as SelectedState;
    emit(SelectedState(index: index, visibleItems: currentState.visibleItems));
  }

  void toggleMenuItemVisibility(int index) async {
    final currentState = state as SelectedState;
    final updatedVisibleItems = Map<int, bool>.from(currentState.visibleItems);
    updatedVisibleItems[index] =
        !updatedVisibleItems[index]!; // Toggle visibility

    emit(SelectedState(
      index: currentState.index,
      visibleItems: updatedVisibleItems,
    ));

    // Save the updated state to SharedPreferences
    await _saveState(updatedVisibleItems);
  }
}
