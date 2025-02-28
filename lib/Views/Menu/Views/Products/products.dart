import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:zaitoon_invoice/Components/Widgets/search_field.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      context.read<ProductsCubit>().loadProductsEvent();
    });
    super.initState();
  }

  final searchProduct = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchField(
                  icon: Icons.search,
                  controller: searchProduct,
                  onChanged: (value) {
                    context
                        .read<ProductsCubit>()
                        .productSearchingEvent(keyword: searchProduct.text);
                  },
                  hintText: locale.productSearch),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ZOutlineButton(
                    height: 40,
                    label: Text(locale.newProductTitle), onPressed: (){
                  showDialog(context: context, builder: (context){
                    return NewProduct();
                  });
                }),
              )
            ],
          ),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsErrorState) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (state is LoadedProductsState) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            locale.noProducts,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(

                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Material(
                          child: ListTile(
                            onTap: (){},
                            visualDensity: VisualDensity(vertical: -4),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                            title: Text(
                              product.productName ?? "null",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 box(text: "${locale.id}: ${product.productId}",context: context),
                                product.averageBuyPrice !=null && product.averageBuyPrice !=0?
                                box(text: "${locale.averagePrice}: ${product.averageBuyPrice?.toStringAsFixed(2) ?? ""}",color: Colors.green,context: context) : SizedBox(),
                                product.totalInventory != null &&
                                        product.totalInventory != 0
                                    ? box(text: "${locale.inventory}: ${product.totalInventory}",context: context)
                                    : SizedBox(),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<ProductsCubit>()
                                    .deleteProduct(id: product.productId!);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return Container(); // Return a blank container if no state matches
              },
            ),
          )
        ],
      ),
    );
  }
  
  Widget box({required String text, Color? color,required BuildContext context}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
      decoration: BoxDecoration(
        color: color ?? Colors.cyan,
        borderRadius: BorderRadius.circular(2)
      ),
      child: Text(text,style: TextStyle(color: Theme.of(context).colorScheme.surface,fontSize:13),),
    );
  }
}
