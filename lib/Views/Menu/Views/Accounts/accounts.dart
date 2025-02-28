import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Components/Widgets/search_field.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Accounts/new_account.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountsCubit>().loadAccountsEvent();
    });
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchField(
                  icon: Icons.search,
                  controller: searchController,
                  onChanged: (value) {
                    context
                        .read<AccountsCubit>()
                        .searchAccountEvent(keyword: searchController.text);
                  },
                  hintText: locale.searchAccounts),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ZOutlineButton(
                    width: 160,
                    height: 40,
                    icon: Icons.add,
                    label: Text(AppLocalizations.of(context)!.newAccountTitle),
                    onPressed: () {
                      showDialog(context: context, builder: (context){
                        return NewAccount();
                      });
                    }),
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<AccountsCubit, AccountsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is AccountsErrorState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_box,
                        size: 45,
                      ),
                      Text(state.error),
                    ],
                  );
                }

                if (state is LoadedAccountsState) {
                  if (state.allAccounts.isEmpty) {
                    return Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_box,size: 25),
                        Text(locale.noAccountMessage),
                      ],
                    ));
                  }

                  return AppBackground(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Column(
                      children: [
                        //Title
                        buildTitle(),
                        Divider(
                            indent: 10,
                            endIndent: 10,
                            color:
                                Theme.of(context).colorScheme.surfaceContainer),
                        //Accounts
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.allAccounts.length,
                              itemBuilder: (context, index) {
                                final account = state.allAccounts[index];
                                return Material(
                                  color: Colors
                                      .transparent, // Keep background transparent
                                  child: InkWell(
                                      hoverColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer
                                          .withValues(alpha: .5),
                                      onTap: () {},
                                      child: _buildAccounts(account)),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Row(
        children: [
          SizedBox(width: 30),
          Text(locale.id, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(width: 70),
          Text(locale.accountName,
              style: Theme.of(context).textTheme.titleSmall),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.balance,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAccounts(Accounts account) {
    final textTheme = Theme.of(context).textTheme;

    Color backgroundColor = Theme.of(context).colorScheme.primary;

    switch (account.accCategoryId) {
      case 1:
        backgroundColor = Colors.lime;
        break;
      case 2:
        backgroundColor = Colors.deepOrangeAccent;
        break;
      case 3:
        backgroundColor = Colors.cyan;
        break;
      case 4:
        backgroundColor = Colors.blue;
        break;
      case 5:
        backgroundColor = Colors.lightGreen;
        break;
      case 6:
        backgroundColor = Colors.purple;
        break;
      case 7:
        backgroundColor = Colors.yellow;
        break;
      case 8:
        backgroundColor = Colors.lightBlueAccent;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Fixed width for account ID text to ensure alignment

          SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(
              textAlign: TextAlign.center,
              account.accId.toString(),
              style: textTheme.bodyMedium,
            ),
          ),

          SizedBox(width: 45),

          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Text(
                  account.accountName!.getFirstLetter,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountName!,
                    style: textTheme.bodyLarge,
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: backgroundColor.withValues(alpha: .2),
                        ),
                        child: Text(account.accCategoryName ?? "",
                            style: textTheme.bodySmall),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: backgroundColor.withValues(alpha: .2),
                        ),
                        child: Text(
                          account.accountNumber ?? account.accId.toString(),
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
