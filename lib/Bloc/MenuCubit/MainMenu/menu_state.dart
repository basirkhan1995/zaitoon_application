part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class SelectedState extends MenuState {
  final int index;
  const SelectedState({required this.index});
  @override
  List<Object> get props => [index];
}
