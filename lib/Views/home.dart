import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/functions.dart';
import 'package:zaitoon_invoice/Views/DatabaseView/databases.dart';
import 'package:zaitoon_invoice/Views/Menu/menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticatedState) {
          Env.gotoReplacement(context, DatabaseManager());
        }
      },
      child: Scaffold(body: MenuPage()),
    );
  }
}
