import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/Inventory/inventory_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/currencies_drop.dart';
import 'package:zaitoon_invoice/Components/Widgets/number_inputfield.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Components/Widgets/quantity_field.dart';
import '../../../../Components/Widgets/units_drop.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final productName = TextEditingController();
  final buyPrice = TextEditingController();
  final sellPrice = TextEditingController();
  final initialQty = TextEditingController();
  final serialNumber = TextEditingController();

  String selectedUnit = "";
  String selectedBuy = "";
  String selectedSell = "";

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildTitle(),
            SizedBox(height: 15),
            buildBody(),
            buildAction(),
          ],
        ),
      ),
    );
  }
  Widget buildTitle(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.shopping_cart_outlined),

          Text(
            "NEW PRODUCT",
            style: Theme.of(context).textTheme.titleLarge,
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.clear,size: 20,color: Theme.of(context).colorScheme.error,)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 5),
        child: Column(
          children: [
            InputFieldEntitled(
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ProductUnitDropdown(
                  width: 100,
                  onSelected: (unit) {
                      selectedUnit = unit;
                  },
                ),
              ),
              title: "Product name",
              isRequire: true,
              controller: productName,
              validator: (value) {
                if (value.isEmpty) {
                  return "Product name is required";
                }
                return null;
              },
            ),
            NumberInputField(
              title: "Quantity",
              controller: initialQty,
            ),

            SizedBox(height: 30),
            InputFieldEntitled(title: "Serial Number"),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: InputFieldEntitled(
                      controller: buyPrice,
                      title: "Buy price",
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: CurrenciesDropdown(
                                        width: 100,
                                        onSelected: (unit) {
                                            selectedBuy = unit;
                                        },
                                      ),
                      ),)),
                Expanded(
                    child: InputFieldEntitled(
                      controller: sellPrice,
                         title: "Sell price",
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: CurrenciesDropdown(
                          width: 100,
                          onSelected: (unit) {
                            selectedSell = unit;
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

  Widget buildAction(){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 25),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ZOutlineButton(
                height: 50,
                label: Text("CREATE"), onPressed: (){}),
            ZOutlineButton(
                backgroundHover: Theme.of(context).colorScheme.error,
                height: 50,
                label: Text("CANCEL"), onPressed: (){
                Navigator.of(context).pop();
            }),


          ],
        ),
      ),
    );
  }

}
