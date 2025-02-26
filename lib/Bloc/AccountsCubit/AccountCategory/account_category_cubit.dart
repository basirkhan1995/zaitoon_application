import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/account_category.dart';
part 'account_category_state.dart';

class AccountCategoryCubit extends Cubit<AccountCategoryState> {
  final Repositories _repositories;
  AccountCategoryCubit(this._repositories) : super(AccountCategoryInitial());

  Future<void> loadAccountCategoriesEvent()async{
    try{
      final response = await _repositories.getAccountCategories();
      emit(LoadedAccountCategoryState(response));
    }catch(e){
      emit(AccountCategoryErrorState(e.toString()));
    }
  }

}
