import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/cubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
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
              return Center(child: Text("No Acconts"));
            }
            return ListView.builder(
                itemCount: state.allAccounts.length,
                itemBuilder: (context, index) {
                  final account = state.allAccounts[index];
                  return _buildAccounts(account);
                });
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildAccounts(Accounts account) {
    Color backgroundColor = Colors.lime;
    if (account.accCategoryId == 8) {
      backgroundColor = Colors.deepOrangeAccent;
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        spacing: 20,
        children: [
          Text(account.accId.toString()),
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Text(account.accountName!.getFirstLetter),
          ),
          Text(account.accountNumber!),
          Text(account.accountName!),
          Text(account.accCategoryName!),
        ],
      ),
    );
  }
}
