import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/Json/backup_model.dart';
import 'package:zaitoon_invoice/Json/databases.dart';
import 'package:zaitoon_invoice/Json/database_info.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  DatabaseInfo? _selectedDatabase;
  DatabaseInfo? get selectedDatabase => _selectedDatabase;

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

  Future<void> loadDatabaseBackupEvent({required String path}) async {
    try {
      final currentState = state;
      if (currentState is LoadedRecentDatabasesState) {
        emit(LoadedRecentDatabasesState(
            allDatabases: currentState.allDatabases,
            selectedDatabase: currentState.selectedDatabase));
      }
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> loadBackupEvent({required String path}) async {
    if (path.isEmpty) {
      emit(DatabaseErrorState("Backup path is empty"));
      return;
    }
    emit(DatabaseLoadingState());
    try {
      final backup = await DatabaseComponents.loadDatabaseBackups(path: path);
      emit(LoadBackupState(backup));
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> backupEvent({required String path, required String dbName}) async {
    if (path.isEmpty || dbName.isEmpty) {
      emit(DatabaseErrorState("Path is empty"));
      return;
    }
    try {
      await DatabaseComponents.createDatabaseBackup(
        databasePath: path.getPathWithoutFileName,
        databaseName: dbName,
      );
      emit(BackupSuccessState()); // Notify UI of successful backup
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  Future<void> getDatabaseByIdEvent(DatabaseInfo dbInfo) async {
    try {
      final currentState = state;
      if (currentState is LoadedRecentDatabasesState) {
        _selectedDatabase = dbInfo;
        emit(LoadedRecentDatabasesState(
          allDatabases: currentState.allDatabases,
          selectedDatabase: _selectedDatabase,
        ));
      }
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
