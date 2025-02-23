import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/search_field.dart';
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

  final searchProduct = TextEditingController();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
              icon: Icons.search,
              controller: searchProduct,
              onChanged: (value) {
                context
                    .read<ProductsCubit>()
                    .productSearchingEvent(keyword: searchProduct.text);
              },
              hintText: "Search Products"),
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
                            "No products available",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                        title: Text(
                          product.productName ?? "Unnamed Product",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product ID: ${product.productId}"),
                            Text(
                              "Avg Price: \$${product.averageBuyPrice?.toStringAsFixed(2) ?? ""}",
                              style: TextStyle(color: Colors.green),
                            ),
                            product.totalInventory != null &&
                                    product.totalInventory != 0
                                ? Text("Inventory: ${product.totalInventory}")
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
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(endIndent: 10,indent: 10, height: 1, color: Colors.grey[300]);
                    },
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
}
