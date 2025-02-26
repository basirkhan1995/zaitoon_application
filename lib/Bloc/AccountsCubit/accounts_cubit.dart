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

  Future<void> searchAccountEvent({required String keyword}) async {
    try {
      final response = await _repositories.searchAccounts(keyword: keyword);
      emit(LoadedAccountsState(response));
      // If no results found and keyword is not empty, show error message
      if (response.isEmpty && keyword.isNotEmpty) {
        emit(AccountsErrorState("No Account Found"));
      }
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  void resetAccountEvent() => emit(AccountsInitial());
}
