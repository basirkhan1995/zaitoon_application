import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';

class DatabaseSettings extends StatefulWidget {
  const DatabaseSettings({super.key});

  @override
  State<DatabaseSettings> createState() => _DatabaseSettingsState();
}

class _DatabaseSettingsState extends State<DatabaseSettings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatabaseCubit>().loadDatabaseEvent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        if (state is LoadedRecentDatabasesState) {
          return Text(state.selectedDatabase?.path ?? "Null");
        }
        if (state is DatabaseErrorState) {
          return Text(state.error);
        }
        return Container();
      },
    );
  }
}
