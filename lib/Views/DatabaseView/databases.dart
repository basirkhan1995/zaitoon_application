import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/Components/Other/functions.dart';
import 'package:zaitoon_invoice/Components/Widgets/language_dropdown.dart';
import 'package:zaitoon_invoice/Components/Widgets/onhover_widget.dart';
import 'package:zaitoon_invoice/Components/Widgets/theme_dropdown.dart';
import 'package:zaitoon_invoice/Components/Widgets/zdialog.dart';
import 'package:zaitoon_invoice/Json/info.dart';
import 'package:zaitoon_invoice/Views/Authentication/login.dart';
import 'package:zaitoon_invoice/Views/Authentication/register.dart';
import 'package:zaitoon_invoice/Views/home.dart';
import '../../Bloc/AuthCubit/cubit/auth_cubit.dart';

class LoadAllDatabases extends StatefulWidget {
  const LoadAllDatabases({super.key});

  @override
  State<LoadAllDatabases> createState() => _LoadAllDatabasesState();
}

class _LoadAllDatabasesState extends State<LoadAllDatabases> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      context.read<DatabaseCubit>().loadDatabaseEvent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          //Header
          header(locale: locale, style: textStyle),
          //Action Buttons
          actionButtons(locale: locale, context: context),
          //Recent Databases
          recentDatabases(locale: locale, style: textStyle),
        ],
      ),
    );
  }

  Widget actionButtons(
      {required AppLocalizations locale, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Row(
        spacing: 15,
        children: [
          HoverWidget(
            onTap: () {
              Env.goto(context, RegisterView());
            },
            label: locale.newDatabase,
            icon: Icons.add,
            fontSize: 18,
            color: Colors.greenAccent.withValues(alpha: .4),
            hoverColor: Colors.green,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          HoverWidget(
            onTap: _browseDatabase,
            label: locale.browse,
            fontSize: 18,
            icon: Icons.storage_rounded,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            color: Colors.cyan.withValues(alpha: .3),
            hoverColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget header({required AppLocalizations locale, required var style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.storage_rounded),
              Text(locale.databases, style: style.titleMedium),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              AppTheme(
                width: 150,
              ),
              AppLanguage(
                width: 150,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget recentDatabases(
      {required AppLocalizations locale, required var style}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.sync_alt),
                Text(locale.recentDatabases, style: style.titleMedium),
              ],
            ),
            Expanded(
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthenticatedState) {
                    Env.gotoReplacement(context, HomeScreen());
                  }
                },
                child: BlocConsumer<DatabaseCubit, DatabaseState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is DatabaseErrorState) {
                      return Text(state.error);
                    }
                    if (state is LoadedRecentDatabasesState) {
                      return ListView.builder(
                          itemCount: state.allDatabases.length,
                          itemBuilder: (context, index) {
                            final dbs = state.allDatabases[index];

                            return ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              horizontalTitleGap: 5,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              title: Text(state.allDatabases[index].name),
                              subtitle: Text(state.allDatabases[index].path
                                  .getPathWithoutFileName),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  Text(dbs.size
                                      .formatBytes(dbs.size)
                                      .toString()),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ZAlertDialog(
                                                title: locale.alertTitle,
                                                content: locale.removeMessage,
                                                icon: Icons.delete,
                                                onYes: () {
                                                  context
                                                      .read<DatabaseCubit>()
                                                      .removeDatabaseEvent(state
                                                          .allDatabases[index]
                                                          .path);
                                                },
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.clear, size: 18)),
                                ],
                              ),
                              onTap: () {
                                context.read<DatabaseCubit>().openDatabase(
                                    dbName: state.allDatabases[index].path);

                                context
                                    .read<DatabaseCubit>()
                                    .getDatabaseByIdEvent(
                                        dbInfo: DatabaseInfo(
                                            name:
                                                state.allDatabases[index].name,
                                            path:
                                                state.allDatabases[index].path,
                                            size:
                                                state.allDatabases[index].size,
                                            backupDirectory: state
                                                .allDatabases[index]
                                                .backupDirectory));
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LoginDialog(dbInfo: dbs);
                                    });
                              },
                            );
                          });
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _browseDatabase() async {
    final dir = await getDownloadsDirectory();
    FilePickerResult? result;
    if (Platform.isAndroid || Platform.isIOS) {
      result = await FilePicker.platform.pickFiles(
        initialDirectory: dir!.path,
        type: FileType.any,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
          initialDirectory: dir!.path,
          type: FileType.custom,
          allowedExtensions: ['db']);
    }

    if (result != null) {
      File dbPath = File(result.files.single.path!);
      setState(() {
        context
            .read<DatabaseCubit>()
            .browseEvent(dbPath: dbPath.path, dbName: dbPath.path);
      });
    }
  }
}
