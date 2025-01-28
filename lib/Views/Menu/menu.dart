import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/Menu/cubit/menu_cubit.dart';
import 'package:zaitoon_invoice/Views/Menu/Components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/dashboard.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/invoice.dart';
import '../../Bloc/AuthCubit/cubit/auth_cubit.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isSelected = false;
  int currentIndex = 0;
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    List<MenuComponents> items = [
      MenuComponents(
          icon: Icons.home, title: "Dashborad", screen: DashboardView()),
      MenuComponents(
          icon: Icons.document_scanner,
          title: "Invoice",
          screen: InvoiceView()),
      MenuComponents(
          icon: Icons.document_scanner,
          title: "Estimate",
          screen: InvoiceView()),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //Side Menu
        sideMenu(items: items),
        //Screen Views
        Expanded(
          child: BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              if (state is SelectedMenuState) {
                currentIndex = state.index;
              }
              return PageView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[currentIndex].screen;
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget sideMenu({required List<MenuComponents> items}) {
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
                    title: Text(state.user.ownerName ?? "null"),
                    subtitle: Text(state.user.userRoleName ?? "null"),
                  );
                }
                return Text(state.toString());
              },
            ),
            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is SelectedMenuState) {
                    currentIndex = state.index;
                  }
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final theme = Theme.of(context).colorScheme;
                        bool isSelected =
                            currentIndex == index; // Currently selected item
                        return Stack(
                          children: [
                            Container(
                              width: 3,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primary
                                      : theme.surface),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<MenuCubit>()
                                    .onChangedMenuEvent(index: index);
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.primary.withValues(alpha: .05)
                                        : theme.surface),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(items[index].icon,
                                        color: isSelected
                                            ? theme.primary
                                            : Colors.black),
                                    Text(
                                      items[index].title,
                                      style: TextStyle(
                                          color: isSelected
                                              ? theme.primary
                                              : Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Icon(Icons.settings),
                        Text("Settings"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().logout();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Icon(Icons.logout_rounded),
                        Text("LOGOUT"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
