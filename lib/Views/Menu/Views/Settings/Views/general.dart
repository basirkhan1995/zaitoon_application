import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/General/general_cubit.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/GeneralSettings/account_settings.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/GeneralSettings/password_settings.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/GeneralSettings/system_settings.dart';
import '../../../Components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../estimate.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool isSelected = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    List<MenuComponents> items = [
      MenuComponents(
          icon: Icons.account_balance_rounded,
          title: locale.accountSettings,
          screen: AccountSettings()),
      MenuComponents(
          icon: Icons.add_home_outlined,
          title: locale.systemSettings,
          screen: SystemSettingsView()),
      MenuComponents(
          icon: Icons.lock,
          title: locale.changePasswordTitle,
          screen: PasswordSettings()),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //Side Menu
        sideMenu(items: items),
        //Screen Views
        Expanded(
          child: BlocBuilder<GeneralCubit, GeneralState>(
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
    final theme = Theme.of(context).colorScheme;
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
        width: 190,
        height: double.infinity,
        child: BlocBuilder<GeneralCubit, GeneralState>(
          builder: (context, state) {
            if (state is SelectedState) {
              currentIndex = state.index;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    bool isSelected =
                        currentIndex == index; // Currently selected item
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 3,
                            height: 35,
                            decoration: BoxDecoration(
                                color:
                                    isSelected ? theme.primary : theme.surface),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<GeneralCubit>()
                                  .onChangedEvent(index: index);
                            },
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primary.withValues(alpha: .07)
                                      : theme.surface),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(items[index].icon,
                                      color: isSelected
                                          ? theme.primary
                                          : theme.secondary),
                                  Text(
                                    items[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? theme.primary
                                            : theme.secondary),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            );
          },
        ));
  }
}
