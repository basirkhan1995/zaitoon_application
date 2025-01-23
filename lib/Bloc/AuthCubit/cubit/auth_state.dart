part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthenticatedState extends AuthState {
  final Users user;
  const AuthenticatedState(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthErrorState extends AuthState {
  final String error;
  const AuthErrorState(this.error);
}
