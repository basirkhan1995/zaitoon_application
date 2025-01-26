import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/button.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Json/database_info.dart';
import 'package:zaitoon_invoice/Json/users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginDialog extends StatefulWidget {
  final DatabaseInfo dbInfo;
  const LoginDialog({super.key, required this.dbInfo});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isError = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      context.read<AuthCubit>().resetState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero, // Removes padding around the title
      actionsPadding: EdgeInsets.zero,

      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear))
          ],
        ),
      ),
      content: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: 350,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.hello(widget.dbInfo.name),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  InputFieldEntitled(
                    icon: Icons.account_circle_rounded,
                    title: "Username",
                    controller: username,
                    onSubmit: (value) => login(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  InputFieldEntitled(
                    icon: Icons.lock,
                    title: "Password",
                    controller: password,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    onSubmit: (value) => login(),
                  ),
                  SizedBox(height: 5),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthErrorState) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                state.error,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  Button(
                      onPressed: () => login(),
                      width: MediaQuery.sizeOf(context).width * .9,
                      height: 50,
                      label: state is LoadingState
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  color: Theme.of(context).colorScheme.surface),
                            )
                          : Text("LOGIN")),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginEvent(
          context: context,
          user: Users(
            username: username.text,
            password: password.text,
          ));
    }
  }
}
