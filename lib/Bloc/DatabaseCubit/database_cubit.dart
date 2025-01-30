import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/Json/backup_model.dart';
import 'package:zaitoon_invoice/Json/databases.dart';
import 'package:zaitoon_invoice/Json/info.dart';

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
      emit(LoadedRecentDatabasesState(allDatabases: dbs));
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> loadDatabaseBackupEvent() async {
    try {
      final dbs = await DatabaseComponents.loadRecentBackupDatabase();
      final currentState = state;
      if (currentState is LoadedRecentDatabasesState) {
        emit(LoadedRecentDatabasesState(
            allDatabases: currentState.allDatabases,
            selectedDatabase: currentState.selectedDatabase,
            allBackupDatabases: dbs));
      }
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> getDatabaseByIdEvent({required DatabaseInfo dbInfo}) async {
    try {
      final currentState = state;

      if (currentState is LoadedRecentDatabasesState) {
        // Only emit the new state if the database info has changed
        emit(LoadedRecentDatabasesState(
          allDatabases: currentState.allDatabases,
          selectedDatabase: dbInfo, // Set the selected database here
          allBackupDatabases: currentState.allBackupDatabases,
        ));
        print(currentState.selectedDatabase?.name ?? "null");
      }
    } catch (e) {
      print(e.toString());
      emit(DatabaseErrorState(
          e.toString())); // Emit error if something goes wrong
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
