import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
     int res = await repositories.changePassword(oldPassword: oldPassword, newPassword: newPassword, userId: userId,message: message);
     if(res>0){
       emit(SuccessPasswordChangedState());
     }
   }catch(e){
     emit(PasswordFailureState(message));
   }

  }


}
