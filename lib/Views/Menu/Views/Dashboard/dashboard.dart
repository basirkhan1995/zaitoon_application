import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/MainMenu/menu_cubit.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';

import '../../../../Components/Widgets/onhover_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final customer = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  label: "New Estimate",
                  fontSize: 18,
                  icon: Icons.shopping_cart_outlined,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  color: Colors.cyan.withValues(alpha: .3),
                  hoverColor: Colors.cyan,
                ),
                HoverWidget(
                  height: 80,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NewProduct();
                        });
                  },
                  label: "Deposit",
                  fontSize: 18,
                  icon: Icons.arrow_downward_rounded,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  color: Colors.cyan.withValues(alpha: .3),
                  hoverColor: Colors.cyan,
                ),
                HoverWidget(
                  height: 80,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NewProduct();
                        });
                  },
                  label: "Withdraw",
                  fontSize: 18,
                  icon: Icons.arrow_upward_rounded,
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
