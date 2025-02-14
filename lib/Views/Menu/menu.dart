import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Components/Widgets/zdialog.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/New/estimate_view.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/estimate.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Reports/Product%20Report/products_report.dart';
import 'package:zaitoon_invoice/Views/Menu/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/settings.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Accounts/accounts.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Dashboard/dashboard.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Invoice/invoice.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Transport/transport.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/products.dart';
import '../../Bloc/AuthCubit/auth_cubit.dart';
import '../../Bloc/MenuCubit/MainMenu/menu_cubit.dart';
import 'dart:typed_data';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isSelected = false;
  bool isExpanded = true;
  int currentIndex = 0;
  double expandedMode = 190;
  double compactMode = 60;
  bool isVisible = false;
  final Uint8List _companyLogo = Uint8List(0);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    List<MenuComponents> items = [
      MenuComponents(
          icon: Icons.add_home_outlined,
          title: locale.dashboard,
          screen: DashboardView()),
      MenuComponents(
          icon: Icons.account_balance_wallet_outlined,
          title: locale.invoice,
          screen: InvoiceView()),
      MenuComponents(
          icon: Icons.event_note, title: locale.estimate, screen: EstimateView()),
      MenuComponents(
          icon: Icons.account_circle_outlined,
          title: locale.accounts,
          screen: AccountsView()),
      MenuComponents(
          icon: Icons.local_shipping_outlined,
          title: locale.transport,
          screen: TransportView()),
      MenuComponents(
          icon: Icons.shopping_cart,
          title: locale.products,
          screen: ProductsView()),
      MenuComponents(
          icon: Icons.info_outline_rounded,
          title: locale.report,
          screen: ProductsReport()),
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
              if (state is SelectedState) {
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
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 0,
                color: Colors.grey.withValues(alpha: .3))
          ],
          borderRadius: BorderRadius.circular(5),
          color: theme.surface,
        ),
        width: isExpanded ? expandedMode : compactMode,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Menu Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: IconButton(
                      onPressed: () => setState(() {
                            isExpanded = !isExpanded;
                          }),
                      icon: Icon(Icons.menu)),
                ),
              ],
            ),

            //Logo
            isExpanded
                ? BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthenticatedState) {
                        final usr = state.user;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              height: 85,
                              width: 85,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: theme.surfaceContainerHighest),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    5), // Match the container's border radius
                                child: usr.companyLogo == null &&
                                        _companyLogo.isEmpty
                                    ? Center(
                                        child: Text(
                                          usr.businessName![0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                      )
                                    : Image.memory(
                                        _companyLogo.isEmpty
                                            ? usr.companyLogo!
                                            : _companyLogo,
                                        fit: BoxFit
                                            .cover, // Ensure the image covers the container
                                        width:
                                            85, // Match the container's width
                                        height:
                                            85, // Match the container's height
                                      ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  )
                : SizedBox(),

            //User Info
            isExpanded
                ? BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthenticatedState) {
                        return ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          hoverColor: theme.primary,
                          splashColor: theme.primary,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SettingsView();
                                });
                          },
                          minVerticalPadding: 0,
                          title: Text(
                            state.user.ownerName ?? "null",
                            style: textTheme.titleMedium,
                          ),
                        );
                      }
                      return Text(state.toString());
                    },
                  )
                : SizedBox(),

            //Menu Items
            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  final currentState = state as SelectedState;
                  final visibleItems = currentState.visibleItems;

                  return ListView.builder(
                      itemCount: visibleItems.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            currentIndex == index; // Currently selected item
                        if (!visibleItems[index]!) {
                          return SizedBox.shrink(); // Hide the item
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Stack(
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
                                      .onChangedEvent(index: index);
                                },
                                child: Container(
                                  height: 35,
                                  padding: EdgeInsets.symmetric(horizontal: 17),
                                  decoration: BoxDecoration(
                                      color: isSelected
                                          ? theme.primary.withValues(alpha: .07)
                                          : theme.surface),
                                  child: Row(
                                    spacing: isExpanded ? 5 : 0,
                                    children: [
                                      Icon(items[index].icon,
                                          color: isSelected
                                              ? theme.primary
                                              : theme.secondary),
                                      isExpanded
                                          ? Text(
                                              items[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: isSelected
                                                      ? theme.primary
                                                      : theme.secondary),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.0, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                spacing: 17,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SettingsView();
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: isExpanded ? 10 : 0,
                      children: [
                        Icon(Icons.settings_outlined, color: theme.secondary),
                        isExpanded
                            ? Text(locale.settings,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: theme.secondary))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ZAlertDialog(
                                title: locale.logout,
                                content: locale.logoutMessage,
                                icon: Icons.power_settings_new_rounded,
                                onYes: () {
                                  context.read<AuthCubit>().logout();
                                });
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: isExpanded ? 10 : 0,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: theme.secondary,
                        ),
                        isExpanded
                            ? Text(
                                locale.logout,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: theme.secondary),
                              )
                            : SizedBox(),
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
