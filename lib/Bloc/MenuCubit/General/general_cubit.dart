import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(SelectedState(index: 0));
  void onChangedEvent({required int index}) {
    emit(SelectedState(index: index));
  }
}
