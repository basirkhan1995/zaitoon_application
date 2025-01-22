part of 'database_cubit.dart';

sealed class DatabaseState extends Equatable {
  const DatabaseState();
}

final class DatabaseInitial extends DatabaseState {
  @override
  List<Object> get props => [];
}

final class DatabaseCreateState extends DatabaseState{
  final String dbName;
  const DatabaseCreateState(this.dbName);
  @override
  List<Object> get props => [dbName];
}

final class DatabaseErrorState extends DatabaseState{
  final String error;
  const DatabaseErrorState(this.error);
  @override
  List<Object> get props => [error];
}
