import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/inventory_model.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final Repositories _repositories;
  InventoryCubit(this._repositories) : super(InventoryInitial());

  Future<void> loadInventoryEvent()async{
  try{
    final inventories = await _repositories.getInventories();
    emit(LoadedInventoryState(inventories));
  }catch(e){
    emit(InventoryErrorState(e.toString()));
  }


  }

}
