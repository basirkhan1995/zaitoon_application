import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/users.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Repositories repositories;
  AuthCubit(this.repositories) : super(AuthInitial());

  void resetState() {
    emit(AuthInitial());
  }


  Future<int> signUpEvent({required Users user, required String dbName}) async {
    try {
      final res = await repositories.createNewDatabase(usr: user, dbName: dbName);
      return res; // Return the result of the operation
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      rethrow; // Optionally rethrow the exception if needed
    }
  }

  Future<void> loginEvent({required Users user}) async {
    emit(LoadingState());
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = await repositories.login(user: user);
      if (response) {
        final result = await repositories.getCurrentUser(
            username: user.username);
        emit(AuthenticatedState(result));
      } else {
        emit(AuthErrorState("Access Denied, Incorrect input"));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> logout()async{
    emit(UnAuthenticatedState());
  }

}
