import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/functions.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'dart:typed_data';

import 'package:zaitoon_invoice/Json/users.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final ownerName = TextEditingController();
  final businessName = TextEditingController();
  final username = TextEditingController();
  final mobile1 = TextEditingController();
  final mobile2 = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  bool _isEnabled = false;
  Users? usr;
  int? businessId;
  final formKey = GlobalKey<FormState>();
  Uint8List _companyLogo = Uint8List(0);

  // Pick and save the image to SQLite
  Future<void> _pickLogoImage() async {
    final imageBytes = await Env.pickImage();
    if (imageBytes != null) {
      setState(() {
        _companyLogo = imageBytes;
      });
    }
  }

  // Future<void> _changeLogo()async{
  //   context.read<AuthCubit>().UpdateCompanyLogoEvent(logo: _companyLogo, userId: usr!.userId!);
  // }

  @override
  void initState() {
    _isEnabled = false;
    super.initState();
  }

  @override
  void dispose() {
    ownerName.dispose();
    businessName.dispose();
    username.dispose();
    mobile1.dispose();
    mobile2.dispose();
    email.dispose();
    address.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthenticatedState) {
                usr = state.user;
                ownerName.text = usr?.ownerName ?? "";
                businessName.text = usr?.businessName ?? "";
                email.text = usr?.email ?? "";
                mobile1.text = usr?.mobile1 ?? "";
                mobile2.text = usr?.mobile2 ?? "";
                address.text = usr?.address ?? "";
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      accountSettings(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget accountSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9),
      width: MediaQuery.of(context).size.width * .5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8)),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 45,
                              child: usr!.companyLogo == null &&
                                      _companyLogo.isEmpty
                                  ? Text(
                                      usr!.businessName![0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    )
                                  : Image.memory(
                                      _companyLogo.isEmpty
                                          ? usr!.companyLogo!
                                          : _companyLogo,
                                      fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        _isEnabled
                            ? Positioned(
                                top: 59,
                                left: 57,
                                child: IconButton(
                                    onPressed: () {
                                      _isEnabled == true
                                          ? _pickLogoImage()
                                          : null;
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usr!.businessName ?? "Business Name",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(usr!.ownerName ?? "Name"),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _isEnabled
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEnabled = true;
                                });
                              },
                              child: Text("EDIT")),
                      _isEnabled
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEnabled = false;
                                });
                              },
                              child: Text("CANCEL"))
                          : const SizedBox(),
                      _isEnabled
                          ? TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  _companyLogo.isNotEmpty
                                      ? context.read<AuthCubit>().updateAccount(
                                          user: Users(
                                              companyLogo: usr!.companyLogo))
                                      : null;

                                  _isEnabled
                                      ? context.read<AuthCubit>().updateAccount(
                                          user: Users(
                                              businessId: usr!.businessId,
                                              ownerName: ownerName.text,
                                              businessName: businessName.text,
                                              address: address.text,
                                              email: email.text,
                                              mobile1: mobile1.text,
                                              mobile2: mobile2.text))
                                      : null;
                                  setState(() {
                                    _isEnabled = false;
                                  });
                                }
                              },
                              child: Text("UPDATE"))
                          : const SizedBox(),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: InputFieldEntitled(
                    isEnabled: _isEnabled,
                    icon: Icons.account_circle_rounded,
                    controller: ownerName,
                    title: "Your name",
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .required("your name");
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InputFieldEntitled(
                    isEnabled: _isEnabled,
                    controller: businessName,
                    icon: Icons.business,
                    title: "Business name",
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .required("business name");
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            InputFieldEntitled(
              isEnabled: _isEnabled,
              controller: email,
              icon: Icons.email,
              title: "email",
            ),
            InputFieldEntitled(
              isEnabled: _isEnabled,
              controller: address,
              icon: Icons.location_on_rounded,
              title: "address",
            ),
            Row(
              children: [
                Expanded(
                  child: InputFieldEntitled(
                    isEnabled: _isEnabled,
                    controller: mobile1,
                    icon: Icons.phone,
                    title: "mobile1",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InputFieldEntitled(
                    isEnabled: _isEnabled,
                    controller: mobile2,
                    icon: Icons.phone_android_rounded,
                    title: "mobile",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
