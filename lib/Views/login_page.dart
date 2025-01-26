import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Json/users.dart';
import 'package:zaitoon_invoice/Views/home.dart';

import '../Components/Other/functions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            Env.gotoReplacement(context, HomeScreen());
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              InputFieldEntitled(title: "Username", controller: username),
              InputFieldEntitled(title: "Username", controller: password),
              TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().loginEvent(
                        context: context,
                        user: Users(
                            username: username.text, password: password.text));
                  },
                  child: Text("LOGIN"))
            ],
          );
        },
      ),
    );
  }
}
