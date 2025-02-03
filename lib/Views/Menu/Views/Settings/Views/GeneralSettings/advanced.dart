import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/MainMenu/menu_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';

class AdvancedView extends StatefulWidget {
  const AdvancedView({super.key});

  @override
  State<AdvancedView> createState() => _AdvancedViewState();
}

class _AdvancedViewState extends State<AdvancedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        width: MediaQuery.of(context).size.width * .3,
        child: Column(
          children: [
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                final visibleItems = (state as SelectedState).visibleItems;

                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text('Estimate'),
                      subtitle: Text("Invoice to give estimate"),
                      value: visibleItems[2],
                      onChanged: (value) {
                        context.read<MenuCubit>().toggleMenuItemVisibility(2);
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Transport'),
                      subtitle: Text(""),
                      value: visibleItems[4],
                      onChanged: (value) {
                        context.read<MenuCubit>().toggleMenuItemVisibility(4);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
