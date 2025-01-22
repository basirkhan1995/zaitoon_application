import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {

  DatabaseCubit() : super(DatabaseInitial());

  void createDatabaseEvent({required String dbName}){
    try{
      DatabaseHelper.initDatabase(dbName);
    }catch(e){
      emit(DatabaseErrorState(e.toString()));
    }
  }
}
