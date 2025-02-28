import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/button.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';
import 'package:zaitoon_invoice/Json/users.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Accounts/account_categories.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final formKey = GlobalKey<FormState>();
  final accountName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  final address = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  int accountCategory = 1;
  String categoryName = "";
  bool isVisible = true;
  void visibility(){
    setState(() {
      isVisible = !isVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero, // Removes padding around the title
      actionsPadding: EdgeInsets.zero,
      content: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height * .9,
        width: MediaQuery.sizeOf(context).width * .35,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTitle(),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.shopping_cart_outlined),
          Text(
            locale.newAccountTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget body() {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            InputFieldEntitled(
              icon: Icons.account_circle_rounded,
              controller: accountName,
              isRequire: true,
              title: locale.accountName,
              validator: (value) {
                if (value.isEmpty) {
                  return locale.required(locale.accountName);
                }
                return null;
              },
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: AccountCategoryDropdown(
                  width: 130,
                  onSelected: (unit) {
                    categoryName = unit;
                  },
                  onSelectedId: (value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        accountCategory = value;
                      });
                    });
                  },
                ),
              ),
            ),
            InputFieldEntitled(
              icon: Icons.phone,
              controller: phone,
              title: locale.mobile,
              inputFormat: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            InputFieldEntitled(
              icon: Icons.email,
              controller: email,
              title: locale.email,
            ),

            InputFieldEntitled(
              icon: Icons.location_city_rounded,
              controller: address,
              title: locale.address,
            ),

            SizedBox(height: 10),

            if (accountCategory == 3)
              InputFieldEntitled(
                icon: Icons.account_circle_rounded,
                controller: userName,
                title: locale.username,
                isRequire: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return locale.required(locale.username);
                  }
                  return null;
                },
              ),
            if (accountCategory == 3)
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: InputFieldEntitled(
                      icon: Icons.lock,
                      controller: password,
                      title: locale.password,
                      securePassword: isVisible,
                      trailing: IconButton(onPressed: visibility, icon: Icon(isVisible? Icons.visibility_off : Icons.visibility,size: 18,)),
                      isRequire: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return locale.required(locale.password);
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: InputFieldEntitled(
                      icon: Icons.lock,
                      controller: confirmPassword,
                      title: locale.confirmPassword,
                      securePassword: isVisible,
                      trailing: IconButton(onPressed: visibility, icon: Icon(isVisible? Icons.visibility_off : Icons.visibility,size: 18,)),
                      isRequire: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return locale.required(locale.confirmPassword);
                        }
                        if (password.text != confirmPassword.text) {
                          return locale.passwordNotMatch;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10), // Adds spacing before buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ZOutlineButton(
                  width: 150,
                  height: 50,
                  label: Text(locale.cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10), // Space between buttons
                Button(
                  width: 150,
                  height: 50,
                  label: Text(locale.create),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AccountsCubit>().addAccountEvent(
                        user: Users(
                          username: userName.text,
                          password: password.text,
                          userId: 1,
                          businessId: 1,
                        ),
                        accounts: Accounts(
                          email: email.text,
                          mobile: phone.text,
                          accountName: accountName.text,
                          accCategoryId: accountCategory,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Extra bottom padding
          ],
        ),
      ),
    );
  }


}
