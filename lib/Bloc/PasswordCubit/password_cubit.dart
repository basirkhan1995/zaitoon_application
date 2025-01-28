import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final Repositories repositories;
  PasswordCubit(this.repositories) : super(PasswordInitial());

  Future<void> changePasswordEvent({
    required int userId,
    required String oldPassword,
    required String newPassword,
    required String message,
  })async{
   emit(PasswordInitial());
   emit(PasswordLoadingState());
   try{
     await Future.delayed(Duration(seconds: 1));
    await repositories.changePassword(oldPassword: oldPassword, newPassword: newPassword, userId: userId,message: message);
    emit(SuccessPasswordChangedState());
   }catch(e){
     emit(PasswordFailureState(message));
   }

  }


}
