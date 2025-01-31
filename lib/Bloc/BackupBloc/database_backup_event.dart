part of 'database_backup_bloc.dart';

sealed class DatabaseBackupEvent extends Equatable {
  const DatabaseBackupEvent();
}

class OpenBackupEvent extends DatabaseBackupEvent{
  final String path;
  const OpenBackupEvent({required this.path});
  @override
  List<Object?> get props => [];
}

class LoadAllBackupEvent extends DatabaseBackupEvent{
  final String path;
  const LoadAllBackupEvent(this.path);
  @override
  List<Object?> get props => [path];
}

class CreateBackupEvent extends DatabaseBackupEvent{
  final String path;
  final String dbName;
  const CreateBackupEvent({required this.path,required this.dbName});
  @override
  List<Object?> get props =>  [path,dbName];

}
