import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/currencies_drop.dart';
import 'package:zaitoon_invoice/Components/Widgets/number_inputfield.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Components/Widgets/products_input.dart';
import '../../../../Components/Widgets/units_drop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  TextEditingController productName = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  TextEditingController initialQty = TextEditingController();
  TextEditingController buyPrice = TextEditingController();
  TextEditingController sellPrice = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed to prevent memory leaks
    initialQty.dispose();
    buyPrice.dispose();
    sellPrice.dispose();
    productName.dispose();
    serialNumber.dispose();
    super.dispose();
  }

  String selectedUnit = "";
  String selectedBuy = "";
  String selectedSell = "";
  int unitId = 1;
  int inventoryId = 1;
  int categoryId = 1;
  final formKey = GlobalKey<FormState>();
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
            mainAxisSize: MainAxisSize.max,
            children: [
              buildTitle(),
              SizedBox(height: 5),
              buildBody(),
              buildAction(),
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

  Widget buildBody() {
    final locale = AppLocalizations.of(context)!;
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
        child: Column(
          children: [
            ProductInputField(
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ProductUnitDropdown(
                  width: 100,
                  onSelected: (unit) {
                    selectedUnit = unit;
                  },
                  onSelectedId: (value) {
                    unitId = value;
                  },
                ),
              ),
              title: locale.productName,
              isRequire: true,
              controller: productName,
              validator: (value) {
                if (value.isEmpty) {
                  return locale.required(locale.productName);
                }
                return null;
              },
            ),
            NumberInputField(
              title: locale.quantity,
              controller: initialQty,
              onSelectedId: (value) {
                inventoryId = value;
              },
            ),
            SizedBox(height: 5),
            InputFieldEntitled(
                title: locale.serialNumber, controller: serialNumber),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: InputFieldEntitled(
                  controller: buyPrice,
                  title: locale.buyPrice,
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: CurrenciesDropdown(
                      width: 100,
                      onSelected: (value) {
                        selectedBuy = value;
                      },
                    ),
                  ),
                )),
                Expanded(
                  child: InputFieldEntitled(
                    controller: sellPrice,
                    title: locale.sellPrice,
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CurrenciesDropdown(
                        width: 100,
                        onSelected: (value) {
                          selectedSell = value;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAction() {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ZOutlineButton(
              height: 50,
              label: Text(locale.create),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<ProductsCubit>().addProductEvent(
                      productName: productName.text.trim(),
                      unit: unitId,
                      category: categoryId,
                      buyPrice: buyPrice.text.isNotEmpty
                          ? double.tryParse(buyPrice.text.trim()) ?? 0.0
                          : 0.0,
                      sellPrice: sellPrice.text.trim().isNotEmpty
                          ? double.tryParse(sellPrice.text.trim()) ?? 0.0
                          : 0.0,
                      inventory: inventoryId,
                      qty: initialQty.text.trim().isNotEmpty
                          ? int.parse(initialQty.text.trim())
                          : 0);
                  Navigator.of(context).pop();
                }
              }),
          ZOutlineButton(
              backgroundHover: Theme.of(context).colorScheme.error,
              height: 50,
              label: Text(locale.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
