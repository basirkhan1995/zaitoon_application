import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(SelectedState(index: 0));

  void onChangedEvent({required int index}) {
    emit(SelectedState(index: index));
  }
}
