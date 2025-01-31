part of 'database_backup_bloc.dart';

sealed class BackupState extends Equatable {
  const BackupState();
}

final class BackupInitial extends BackupState {
  @override
  List<Object> get props => [];
}

final class LoadedBackupState extends BackupState{
  final List<DatabaseBackupInfo> backupInfo;
  const LoadedBackupState(this.backupInfo);
  @override
  List<Object> get props => [backupInfo];
}

final class BackupErrorState extends BackupState{
  final String error;
  const BackupErrorState(this.error);
  @override
  List<Object> get props => [error];
}