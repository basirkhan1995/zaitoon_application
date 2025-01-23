import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/users.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Repositories _repositories;
  AuthCubit(this._repositories) : super(AuthInitial());

  Future<void> signUpEvent({required Users user}) async {
    try {
      _repositories.createUser(usr: user);
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> loginEvent({required Users user}) async {
    try {
      final response = await _repositories.login(user: user);
      if (response) {
        final result = await _repositories.getCurrentUser(
            username: user.copyWith(username: user.username));
        emit(AuthenticatedState(result));
      } else {
        emit(AuthErrorState("Authentication Failed"));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
