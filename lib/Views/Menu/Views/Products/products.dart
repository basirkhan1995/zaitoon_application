import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';

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

  final keyword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return NewProduct();
                });
          }),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsErrorState) {
            return Text(state.error);
          }
          if (state is LoadedProductsState) {
            if (state.products.isEmpty) {
              return Text("No products");
            }
            return Column(
              children: [
                TextField(
                  controller: keyword,
                  onChanged: (value){
                    context.read<ProductsCubit>().productSearchingEvent(keyword: keyword.text);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.products[index].productName ?? "null"),
                          subtitle:
                              Text(state.products[index].totalInventory.toString()),
                          trailing: IconButton(
                              onPressed: () {
                                context.read<ProductsCubit>().deleteProduct(
                                    id: state.products[index].productId!);
                              },
                              icon: Icon(Icons.delete)),
                        );
                      }),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
