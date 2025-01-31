import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Views/DatabaseView/databases.dart';
import '../../../../../Bloc/BackupBloc/database_backup_bloc.dart';
import '../../../../../Components/Other/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../Json/info.dart';

class DatabaseSettings extends StatefulWidget {
  const DatabaseSettings({super.key});

  @override
  State<DatabaseSettings> createState() => _DatabaseSettingsState();
}

class _DatabaseSettingsState extends State<DatabaseSettings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      final db = context.read<DatabaseCubit>().selectedDatabase;
      context.read<BackupBloc>().add(LoadAllBackupEvent(db!.backupDirectory));
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          dbInfo(),
          Expanded(child: backupView()),
        ],
      ),
    );
  }

  Widget backupView() {
    return BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if(state is UnAuthenticatedState){
      Env.gotoReplacement(context, const DatabaseManager());
    }
  },
  child: BlocConsumer<BackupBloc, BackupState>(
      listener: (context, state) {
        if (state is BackupErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoadedBackupState) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.backupInfo.length,
            itemBuilder: (context, index) {

              final backup = state.backupInfo[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                child: ListTile(
                  hoverColor: Theme.of(context).colorScheme.surface.withValues(alpha: .25,blue: .25,green: .25),
                  splashColor: Theme.of(context).colorScheme.onPrimary,
                  tileColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  horizontalTitleGap: 5,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    context.read<AuthCubit>().logout();
                    context.read<BackupBloc>().add(OpenBackupEvent(path: state.backupInfo[index].path));
                  },
                  title: Text(backup.name.getFileName,style: Theme.of(context).textTheme.titleMedium),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(backup.size.formatBytes(backup.size)),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(backup.path.getPathWithoutFileName),
                      Text(Env.gregorianDateTimeForm(state.backupInfo[index].dateTime.toString())),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    ),
);
  }

  Widget dbInfo() {
    final localization = AppLocalizations.of(context)!;
    final db = context.read<DatabaseCubit>().selectedDatabase;
    return AppBackground(
      child: BlocListener<BackupBloc, BackupState>(
  listener: (context, state) {
    if(state is BackupSuccessState){
      context
          .read<DatabaseCubit>()
          .getDatabaseByIdEvent(DatabaseInfo(
          name: db!.name,
          path: db.path,
          size: db.size,
          backupDirectory:
          db.backupDirectory));
    }
  },
  child: BlocBuilder<DatabaseCubit, DatabaseState>(
        builder: (context, state) {
          final db = context.read<DatabaseCubit>().selectedDatabase;
          if (db != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(db.name,style: Theme.of(context).textTheme.titleMedium),
                Text(db.backupDirectory),
                Text(db.size.formatBytes(db.size)),
                SizedBox(height: 5),
                Row(
                  children: [
                    ZOutlineButton(
                      height: 40,
                      label: Text(localization.backup),
                      icon: Icons.backup_outlined,
                      onPressed: () {
                        context.read<BackupBloc>().add(CreateBackupEvent(
                            path: db.path.getPathWithoutFileName,
                            dbName: db.name));

                        context.read<DatabaseCubit>().getDatabaseByIdEvent(DatabaseInfo(
                            name: db.name,
                            path: db.path,
                            size: db.size,
                            backupDirectory:
                            db.backupDirectory));
                      },
                    ),

                  ],
                ),
              ],
            );
          } else {
            return Text('No database selected');
          }
        },
      ),
),
    );
  }
}