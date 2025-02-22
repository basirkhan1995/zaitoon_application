import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/MainMenu/menu_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../Components/Widgets/onhover_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                HoverWidget(
                  height: 80,
                  onTap: () {
                    context.read<MenuCubit>().onChangedEvent(index: 2);
                  },
                  label: locale.newEstimate,
                  fontSize: 18,
                  icon: Icons.shopping_cart_outlined,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  color: Colors.cyan.withValues(alpha: .3),
                  hoverColor: Colors.cyan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
