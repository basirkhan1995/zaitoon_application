import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/Json/database_info.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  Future<void> openDatabase({required String dbName}) async {
    try {
      await DatabaseHelper.openDB(dbName);
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> browseEvent(
      {required String dbPath, required String dbName}) async {
    try {
      await DatabaseHelper.browseDatabase(path: dbPath, dbName: dbName);
      await loadDatabaseEvent();
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> loadDatabaseEvent() async {
    try {
      final dbs = await DatabaseComponents.loadRecentDatabase();
      emit(LoadedRecentDatabasesState(dbs));
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> removeDatabaseEvent(String dbName) async {
    try {
      if (dbName.isNotEmpty) {
        await DatabaseComponents.removeDatabasePath(dbName);
        await loadDatabaseEvent();
      }
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }
}
