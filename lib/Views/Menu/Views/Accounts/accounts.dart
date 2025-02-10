import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/cubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountsCubit>().loadAccounts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AccountsCubit, AccountsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AccountsErrorState) {
            return Text(state.error);
          }

          if (state is LoadedAccountsState) {
            if (state.allAccounts.isEmpty) {
              return Center(child: Text("No Accounts"));
            }
            return AppBackground(
              child: Column(
                children: [
                  //Title
                  buildTitle(),
                  Divider(indent: 10, endIndent: 10),
                  //Accounts
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.allAccounts.length,
                        itemBuilder: (context, index) {
                          final account = state.allAccounts[index];
                          return _buildAccounts(account);
                        }),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text("ID", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(width: 30),
          Text("Account Name", style: Theme.of(context).textTheme.titleMedium),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Balance",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
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
      case 2:
        backgroundColor = Colors.deepOrangeAccent;
      case 3:
        backgroundColor = Colors.cyan;
      case 4:
        backgroundColor = Colors.blue;
      case 5:
        backgroundColor = Colors.lightGreen;
      case 6:
        backgroundColor = Colors.purple;
      case 7:
        backgroundColor = Colors.yellow;
      case 8:
        backgroundColor = Colors.lightBlueAccent;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        children: [
          SizedBox(width: 5),
          Text(account.accId.toString()),
          SizedBox(width: 5),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: backgroundColor,
                child: Text(account.accountName!.getFirstLetter,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountName!,
                    style: textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: backgroundColor.withValues(alpha: .2)),
                          child: Text(account.accCategoryName!,
                              style: textTheme.bodySmall)),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: backgroundColor.withValues(alpha: .2)),
                          child: Text(account.accountNumber!,
                              style: textTheme.bodySmall)),
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
