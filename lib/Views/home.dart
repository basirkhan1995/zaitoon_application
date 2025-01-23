import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if(state is AuthenticatedState){
            return Text(state.user.businessName!);
          }
          return Text(state.toString());
        },
      ),
    );
  }
}
