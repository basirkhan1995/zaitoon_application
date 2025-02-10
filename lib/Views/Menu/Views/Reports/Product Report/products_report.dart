import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';

class ProductsReport extends StatefulWidget {
  const ProductsReport({super.key});

  @override
  State<ProductsReport> createState() => _ProductsReportState();
}

class _ProductsReportState extends State<ProductsReport> {
  @override
  void initState() {

    super.initState();
  }

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
          if (state is ReportProductsState) {
            if (state.products.isEmpty) {
              return Text("No products");
            }

            return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.products[index].productName??""),
                    subtitle:
                        Text(state.products[index].inventoryName ?? ""),
                    trailing:
                        Text(state.products[index].currentInventory.toString()),
                  );
                });
          }
          return Container();
        },
      ),
    );
  }
}
