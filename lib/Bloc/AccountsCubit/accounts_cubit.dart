import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repositories _repositories;
  AccountsCubit(this._repositories) : super(AccountsInitial());

  Future<void> loadAccountsEvent() async {
    try {
      final accounts = await _repositories.getAccounts();
      emit(LoadedAccountsState(accounts));
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  Future<void> searchAccountEvent({required String keyword})async{
    try{
      final filteredAccount = await _repositories.searchAccounts(keyword: keyword);
      emit(LoadedAccountsState(filteredAccount));
      if(filteredAccount.isEmpty){
        emit(AccountsErrorState("No account found"));
      }if(keyword.isEmpty){
      resetAccountEvent();
     }

    }catch(e){
      emit(AccountsErrorState(e.toString()));
    }
  }

  void resetAccountEvent()=> emit(AccountsInitial());
}
