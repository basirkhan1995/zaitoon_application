part of 'password_cubit.dart';

@immutable
sealed class PasswordState {}

final class PasswordInitial extends PasswordState {}
final class PasswordLoadingState extends PasswordState{}

final class SuccessPasswordChangedState extends PasswordState{

}

final class PasswordFailureState extends PasswordState{
  final String error;
  PasswordFailureState(this.error);
}