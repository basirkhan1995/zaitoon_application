part of 'accounts_cubit.dart';

sealed class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object> get props => [];
}

final class AccountsInitial extends AccountsState {}

final class LoadedAccountsState extends AccountsState {
  final List<Accounts> allAccounts;
  const LoadedAccountsState(this.allAccounts);

  @override
  List<Object> get props => [allAccounts];
}

final class AccountsErrorState extends AccountsState {
  final String error;
  const AccountsErrorState(this.error);
}
