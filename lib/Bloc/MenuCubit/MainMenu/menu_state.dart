part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class SelectedState extends MenuState {
  final int index;
  final Map<int, bool> visibleItems; // Track visibility of menu items

  const SelectedState({required this.index, required this.visibleItems});

  @override
  List<Object> get props => [index, visibleItems];
}
