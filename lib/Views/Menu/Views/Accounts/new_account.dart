import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/button.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';
import 'package:zaitoon_invoice/Json/users.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/account_categories.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final accountName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  final userName = TextEditingController();
  final password = TextEditingController();
  int accountCategory = 1;
  String categoryName = "";
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
        width: MediaQuery.sizeOf(context).width * .4,
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
            locale.newProductTitle,
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
                      color: Theme.of(context).colorScheme.error,
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          InputFieldEntitled(
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
                width: 150,
                onSelected: (unit) {
                  categoryName = unit;
                },
                onSelectedId: (value) {
                  accountCategory = value;
                },
              ),
            ),
          ),
          InputFieldEntitled(
            controller: phone,
            title: locale.mobile,
          ),
          InputFieldEntitled(
            controller: email,
            title: locale.email,
          ),
          accountCategory == 1
              ? InputFieldEntitled(
                  controller: userName,
                  title: locale.username,
                )
              : SizedBox(),
          accountCategory == 1
              ? InputFieldEntitled(
                  controller: password,
                  title: locale.password,
                )
              : SizedBox(),
          Button(
              label: Text("Create"),
              onPressed: () {
                context.read<AccountsCubit>().addAccountEvent(
                    user: Users(
                        username: userName.text,
                        password: password.text,
                        userId: 1,
                        businessId: 1),
                    accounts: Accounts(
                      email: email.text,
                      mobile: phone.text,
                      accountName: accountName.text,
                      accCategoryId: accountCategory,
                    ));
              })
        ],
      ),
    );
  }
}
