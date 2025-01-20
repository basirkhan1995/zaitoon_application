import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEW"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputFieldEntitled(
                title: "Full Name",
                icon: Icons.person,
              ),
              InputFieldEntitled(title: "Business Name"),
              InputFieldEntitled(title: "Phone"),
            ],
          ),
        ),
      ),
    );
  }
}
