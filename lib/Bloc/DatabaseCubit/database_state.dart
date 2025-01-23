part of 'database_cubit.dart';

sealed class DatabaseState extends Equatable {
  const DatabaseState();
}

final class DatabaseInitial extends DatabaseState {
  @override
  List<Object> get props => [];
}

final class LoadedRecentDatabasesState extends DatabaseState{
  final List<DatabaseInfo> recentDbs;
  const LoadedRecentDatabasesState(this.recentDbs);
  @override
  List<Object> get props => [recentDbs];
}

final class DatabaseErrorState extends DatabaseState{
  final String error;
  const DatabaseErrorState(this.error);
  @override
  List<Object> get props => [error];
}
