import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(SelectedMenuState(index: 0));

  void onChangedMenuEvent({required int index}) {
    emit(SelectedMenuState(index: index));
  }
}
