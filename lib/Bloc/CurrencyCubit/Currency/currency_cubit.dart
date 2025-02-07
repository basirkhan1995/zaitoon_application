import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/currencies_model.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final Repositories _repositories;
  CurrencyCubit(this._repositories) : super(CurrencyInitial());

  Future<void> loadCurrenciesEvent()async{
   try{
     final currencies = await _repositories.getCurrencies();
     emit(LoadedCurrencyState(currencies));
   }catch(e){
     emit(CurrencyErrorState(e.toString()));
   }

  }


}
