import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';

import '../../Json/backup_model.dart';

part 'database_backup_event.dart';
part 'database_backup_state.dart';

class BackupBloc extends Bloc<DatabaseBackupEvent, BackupState> {
  BackupBloc() : super(BackupInitial()) {

    on<LoadAllBackupEvent>((event, emit) async{
      try{
       final backup = await DatabaseComponents.loadDatabaseBackups(path: event.path);
       emit(LoadedBackupState(backup));
      }catch(e){
        emit(BackupErrorState(e.toString()));
      }
    });

    on<CreateBackupEvent>((event,emit)async{
      try{
        await DatabaseComponents.createDatabaseBackup(databasePath: event.path, databaseName: event.dbName);
        String complete = join(event.path,"${event.dbName} Backup");
        add(LoadAllBackupEvent(complete));
      }catch(e){
        emit(BackupErrorState(e.toString()));
      }
    });

   on<OpenBackupEvent>((event,emit)async{
     try{
       await DatabaseHelper.backupOpener(path: event.path);
     }catch(e){
       emit(BackupErrorState(e.toString()));
     }
   });
  }
}
