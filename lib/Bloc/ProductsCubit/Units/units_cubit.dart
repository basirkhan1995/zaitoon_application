import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/product_unit.dart';

part 'units_state.dart';

class UnitsCubit extends Cubit<UnitsState> {
  final Repositories _repositories;
  UnitsCubit(this._repositories) : super(UnitsInitial());

  Future<void> loadProductUnitEvent()async{
    try{
      final units = await _repositories.getProductUnits();
      emit(LoadedProductsUnitsState(units));
    }catch(e){
      emit(ProductUnitsErrorState(e.toString()));
    }
  }
}

