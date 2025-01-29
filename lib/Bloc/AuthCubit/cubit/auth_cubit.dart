import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Repositories repositories;

  AuthCubit(this.repositories) : super(AuthInitial());

  void resetState() {
    emit(AuthInitial());
  }

  Future<int> signUpEvent(
      {required Users user,
      required String path,
      required String dbName}) async {
    try {
      final res = await repositories.createNewDatabase(
          usr: user, path: path, dbName: dbName);
      return res; // Return the result of the operation
    } catch (e) {
      emit(AuthErrorState(e.toString(), null));
      rethrow; // Optionally rethrow the exception if needed
    }
  }

  void loginEvent(
      {required Users user, required AppLocalizations localizations}) async {
    emit(LoadingState());
    await Future.delayed(Duration(seconds: 1));
    final result = await repositories.login(user: user);
    emit(AuthInitial());

    if (result['success']) {
      final usr = await repositories.getCurrentUser(username: user.username);
      emit(AuthenticatedState(usr));
    } else {
      String message;

      switch (result['code']) {
        case 'USER_NOT_FOUND':
          message = localizations.userNotFound;
          break;
        case 'WRONG_PASSWORD':
          message = localizations.incorrectPassword;
          break;
        case 'USER_INACTIVE':
          message = localizations.userInactive;
          break;
        default:
          message = localizations.incorrectPassword;
      }

      emit(AuthErrorState(message, null));
    }
  }

  Future<void> updateAccount({required Users user}) async {
    try {
      await repositories.updateAccount(user: user);
      final usr = await repositories.getUserById(userId: user.userId!);
      emit(AuthenticatedState(usr));
    } catch (e) {
      emit(AuthErrorState(e.toString(), null));
    }
  }

  Future<void> logout() async {
    emit(UnAuthenticatedState());
  }
}
