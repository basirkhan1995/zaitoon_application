import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/CurrencyCubit/Currency/currency_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Json/currencies_model.dart';
import '../../../../../../Components/Widgets/background.dart';
import '../../../../../../Components/Widgets/button.dart';
import '../../../../../../Components/Widgets/inputfield_entitled.dart';


class CurrencySettingsView extends StatefulWidget {
  const CurrencySettingsView({super.key});

  @override
  State<CurrencySettingsView> createState() => _CurrencySettingsViewState();
}

class _CurrencySettingsViewState extends State<CurrencySettingsView> {
  final crName = TextEditingController();
  final crCode = TextEditingController();
  final crSymbol = TextEditingController();

  bool isUpdateMode = false;
  int? currencyId;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    isUpdateMode = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
        context.read<CurrencyCubit>().loadCurrenciesEvent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

        body: BlocConsumer<CurrencyCubit, CurrencyState>(
          listener: (context, state) {
            if(state is LoadedCurrencyState){
              crName.clear();
              crSymbol.clear();
              crCode.clear();
            }
            if(state is CurrencyInitial){
              crName.clear();
              crSymbol.clear();
              crCode.clear();
              isUpdateMode = false;
            }
          },
          builder: (context, state) {
            if(state is LoadedCurrencyState){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 4),
                child: Row(
                  children: [
                    AppBackground(
                      width: 500,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            height: 70,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8))),
                            child: Column(
                              children: [
                                //Title
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            locale.currency,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                        ],
                                      ),

                                      ZOutlineButton(
                                        width: 160,
                                        height: 40,
                                        icon: Icons.add_circle_outline_rounded,
                                        label: Text(locale.newCurrency),
                                        onPressed: () {
                                          setState(() {
                                            isUpdateMode = false;
                                          });
                                          _newCurrency();
                                        },
                                      ),

                                    ],
                                  ),
                                ),

                                //Tab bar
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: state.currencies.length,
                                itemBuilder: (context,index){
                                  return Material(
                                    child: ListTile(
                                      visualDensity: const VisualDensity(vertical: -4),
                                      title: Text(state.currencies[index].currencyCode),
                                      leading: CircleAvatar(child: Text(state.currencies[index].currencyId.toString())),
                                      trailing: IconButton(
                                          onPressed: (){
                                          context.read<CurrencyCubit>().deleteCurrencyEvent(id: state.currencies[index].currencyId!);
                                        }, icon:  Icon(Icons.delete)),
                                      subtitle: Text("${state.currencies[index].currencyName} (${state.currencies[index].symbol})" ),
                                      onTap: (){
                                        setState(() {
                                          crName.text = state.currencies[index].currencyName??"";
                                          crCode.text = state.currencies[index].currencyCode;
                                          crSymbol.text = state.currencies[index].symbol??"";
                                          currencyId = state.currencies[index].currencyId;
                                          isUpdateMode = true;
                                          _newCurrency();
                                        });
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
            return Text(state.toString());
          },
        )
    );
  }

  void _newCurrency(){
    final locale = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (context){
      return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(isUpdateMode ?  locale.edit : locale.newKeyword ,
                          style: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.primary)),
                    ),
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                          setState(() {
                            isUpdateMode = false;
                            crName.clear();
                            crSymbol.clear();
                            crCode.clear();
                          });
                        },
                        icon: const Icon(Icons.clear)),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.currency,style: const TextStyle(fontSize: 15),)
                    ],
                  ),
                ),
              ],
            ),
          ),
          content: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputFieldEntitled(
                    isRequire: true,
                    controller: crName,
                    title: AppLocalizations.of(context)!.currency_name,
                    validator: (value){
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.currency_name);
                      }
                      return null;
                    },
                  ),

                  InputFieldEntitled(
                    isRequire: true,
                    controller: crCode,
                    title: AppLocalizations.of(context)!.currency_code,
                    validator: (value){
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.currency_code);
                      }
                      return null;
                    },
                  ),

                  InputFieldEntitled(
                    isRequire: true,
                    controller: crSymbol,
                    title: AppLocalizations.of(context)!.currnecy_symbol,
                    validator: (value){
                      if(value.isEmpty){
                        return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.currnecy_symbol);
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  isUpdateMode? Button(
                      height: 45,
                      width: MediaQuery.sizeOf(context).width,
                      label: Text(AppLocalizations.of(context)!.update),
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                        context.read<CurrencyCubit>().editCurrencyEvent(currency: CurrenciesModel(
                             currencyCode: crCode.text,
                             currencyName: crName.text,
                             symbol: crSymbol.text,
                             currencyId: currencyId
                         ));
                        Navigator.of(context).pop();
                        }
                      }) : Button(
                      height: 45,
                      width: MediaQuery.sizeOf(context).width,
                      label: Text(AppLocalizations.of(context)!.create),
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          context.read<CurrencyCubit>().addCurrencyEvent(
                              currency:
                              CurrenciesModel(
                                  currencyCode: crCode.text,
                                  currencyName: crName.text,
                                  symbol: crSymbol.text
                              ));
                          Navigator.pop(context);
                        }
                      })
                ],
              ),
            ),
          )
      );
    });
  }
}
