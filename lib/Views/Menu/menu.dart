import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/AuthCubit/cubit/auth_cubit.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    List<String> menuItems = [
      "Dashboard",
      "Invoice",
      "Estimate",
      "Customers",
    ];

    List<IconData> icons = [
      Icons.home,
      Icons.document_scanner_rounded,
      Icons.file_copy,
      Icons.account_circle_rounded
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        box(menuItems, icons),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthenticatedState) {
                    return Text(state.user.userRoleName ?? "null");
                  }
                  return Text(state.toString());
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget box(List<String> items, List<IconData> icons) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 0,
                color: Colors.grey.withValues(alpha: .3))
          ],
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.surface,
        ),
        width: 200,
        height: double.infinity,
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  return ListTile(
                    title: Text(state.user.ownerName??""),
                    subtitle: Text(state.user.userRoleName??""),
                  );
                }
                return Container();
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: Icon(icons[index]),
                      title: Text(items[index]),
                    );
                  }),
            ),
          ],
        ));
  }
}
