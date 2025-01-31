part of 'database_cubit.dart';

sealed class DatabaseState extends Equatable {
  const DatabaseState();
}

final class DatabaseInitial extends DatabaseState {
  @override
  List<Object> get props => [];
}

final class DatabaseLoadingState extends DatabaseState{
  @override
  List<Object> get props => [];
}

final class LoadBackupState extends DatabaseState {
  final List<DatabaseBackupInfo> backup;
  const LoadBackupState(this.backup);
  @override
  List<Object> get props => [backup];
}

final class BackupSuccessState extends DatabaseState{
  @override
  List<Object> get props => [];
}

final class LoadedRecentDatabasesState extends DatabaseState {
  final List<Databases> allDatabases;
  final DatabaseInfo? selectedDatabase;
  final List<DatabaseBackupInfo>? allBackupDatabases;

  const LoadedRecentDatabasesState(
      {required this.allDatabases,
      this.allBackupDatabases,
      this.selectedDatabase});
  @override
  List<Object> get props => [allDatabases];
}

final class DatabaseErrorState extends DatabaseState {
  final String error;
  const DatabaseErrorState(this.error);
  @override
  List<Object> get props => [error];
}
