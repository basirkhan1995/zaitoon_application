import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/EstimateCubit/estimate_cubit.dart';
import 'package:zaitoon_invoice/Bloc/EstimateCubit/estimate_state.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

class EstimateItemsList extends StatelessWidget {
  const EstimateItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<EstimateCubit>().addRow();
              },
              child: Text('Add Row'),
            ),
          ),
          Expanded(
            child: BlocBuilder<EstimateCubit, EstimateState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return EstimateItemRow(item: item, index: index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EstimateItemRow extends StatelessWidget {
  final EstimateItemsModel item;
  final int index;

  const EstimateItemRow({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Row ${item.rowNumber}'),
            TextField(
              decoration: InputDecoration(labelText: 'Item Name'),
              onChanged: (value) {
                final updatedItem = item.copyWith(itemName: value);
                context.read<EstimateCubit>().updateRow(index, updatedItem);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final quantity = int.tryParse(value) ?? 0;
                final updatedItem = item.copyWith(quantity: quantity);
                context.read<EstimateCubit>().updateRow(index, updatedItem);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0;
                final updatedItem = item.copyWith(amount: amount);
                context.read<EstimateCubit>().updateRow(index, updatedItem);
              },
            ),
            // Add more fields for tax, discount, total, etc.
          ],
        ),
      ),
    );
  }
}
