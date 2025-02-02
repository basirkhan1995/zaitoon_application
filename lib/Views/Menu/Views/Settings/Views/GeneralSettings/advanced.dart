import 'package:flutter/material.dart';
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
          children: [],
        ),
      ),
    );
  }
}
