part of 'general_cubit.dart';

@immutable
sealed class GeneralState {}

final class SelectedState extends GeneralState {
  final int index;
  SelectedState({required this.index});
}