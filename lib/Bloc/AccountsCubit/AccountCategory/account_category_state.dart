part of 'account_category_cubit.dart';

sealed class AccountCategoryState extends Equatable {
  const AccountCategoryState();
}

final class AccountCategoryInitial extends AccountCategoryState {
  @override
  List<Object> get props => [];
}

final class LoadedAccountCategoryState extends AccountCategoryState{
  final List<AccountCategoryModel> categories;
  const LoadedAccountCategoryState(this.categories);
  @override
  List<Object> get props => [categories];
}

final class AccountCategoryErrorState extends AccountCategoryState{
  final String error;
  const AccountCategoryErrorState(this.error);
  @override
  List<Object> get props => [error];
}
