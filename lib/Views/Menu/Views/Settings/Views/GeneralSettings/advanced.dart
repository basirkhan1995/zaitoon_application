import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/MainMenu/menu_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdvancedView extends StatefulWidget {
  const AdvancedView({super.key});

  @override
  State<AdvancedView> createState() => _AdvancedViewState();
}

class _AdvancedViewState extends State<AdvancedView> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBackground(
            width: MediaQuery.of(context).size.width * .3,
            child: Column(
              children: [
                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    final visibleItems = (state as SelectedState).visibleItems;

                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(localization.estimate,
                              style: theme.titleMedium),
                          subtitle: Text("Invoice to give estimate"),
                          value: visibleItems[2],
                          onChanged: (value) {
                            context
                                .read<MenuCubit>()
                                .toggleMenuItemVisibility(2);
                          },
                        ),
                        CheckboxListTile(
                          title: Text(localization.transport,
                              style: theme.titleMedium),
                          subtitle: Text("Transportation Company Management"),
                          value: visibleItems[4],
                          onChanged: (value) {
                            context
                                .read<MenuCubit>()
                                .toggleMenuItemVisibility(4);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
