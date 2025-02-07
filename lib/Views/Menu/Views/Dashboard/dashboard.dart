import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';

import '../../../../Components/Widgets/onhover_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            HoverWidget(
              height: 80,
              onTap: () {
                showDialog(context: context, builder: (context){
                  return NewProduct();
                });
              },
              label: "NEW PRODUCT",
              fontSize: 18,
              icon: Icons.shopping_cart_outlined,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              color: Colors.cyan.withValues(alpha: .3),
              hoverColor: Colors.cyan,
            ),
            SizedBox(width: 10),
            HoverWidget(
              height: 80,
              onTap: () {},
              label: "NEW PRODUCT",
              fontSize: 18,
              icon: Icons.shopping_cart_outlined,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              color: Colors.cyan.withValues(alpha: .3),
              hoverColor: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}
