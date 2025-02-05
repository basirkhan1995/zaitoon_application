import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repositories _repositories;
  AccountsCubit(this._repositories) : super(AccountsInitial());

  Future<void> loadAccounts() async {
    try {
      final accounts = await _repositories.getAccounts();
      emit(LoadedAccountsState(accounts));
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }
}
