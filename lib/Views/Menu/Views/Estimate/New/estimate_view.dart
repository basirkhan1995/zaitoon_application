import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Bloc/EstimateCubit/estimate_cubit.dart';
import '../../../../../Json/z_estimate.dart';
import 'estimate_items.dart';
class ZEstimate extends StatelessWidget {
  const ZEstimate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
            columnWidths: const {
              0: FixedColumnWidth(40), // Row Number
              1: FlexColumnWidth(10), // Item name gets more space
              2: FixedColumnWidth(80), // Quantity
              3: FixedColumnWidth(100), // Unit price
              4: FixedColumnWidth(100), // Discount
              5: FixedColumnWidth(80), // Tax
              6: FixedColumnWidth(110), // Total
              7: FixedColumnWidth(60), // Action Button
            },
            border: TableBorder.symmetric(
              outside: BorderSide(
                  color: Colors.grey.withValues(alpha: .2),
                  width: 1), // Table border outline
              inside: BorderSide.none, // No internal borders
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary),
                children: [
                  _buildHeaderText('#',TextAlign.center, context),
                  _buildHeaderText('Item Name',TextAlign.left,context),
                  _buildHeaderText('Qty',TextAlign.left,context),
                  _buildHeaderText('Amount',TextAlign.left,context),
                  _buildHeaderText('Tax',TextAlign.left,context),
                  _buildHeaderText('Discount',TextAlign.left,context),
                  _buildHeaderText('Total',TextAlign.left,context),
                  _buildHeaderText('Action',TextAlign.left,context),
                ],
              ),
            ],
          ),
        ),
        // List of Rows
        Expanded(
          child: BlocBuilder<EstimateCubit, List<ZEstimateModel>>(
            builder: (context, rows) {
              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return EstimateRow(
                    row: row,
                    onChanged: (updatedRow) {
                      context.read<EstimateCubit>().updateRow(updatedRow);
                    },
                    onRemove: () {
                      context.read<EstimateCubit>().removeRow(row.rowNumber!);
                    },
                  );
                },
              );
            },
          ),
        ),


        // Subtotal, VAT, and Total Section
        BlocBuilder<EstimateCubit, List<ZEstimateModel>>(
          builder: (context, rows) {
            final subtotal = context.read<EstimateCubit>().calculateSubtotal();
            final vat = context.read<EstimateCubit>().calculateVAT();
            final total = context.read<EstimateCubit>().calculateTotal();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildSummaryRow('Subtotal', subtotal),
                    _buildSummaryRow('VAT (15%)', vat),
                    const Divider(),
                    _buildSummaryRow('Total', total, isTotal: true),
                  ],
                ),
              ),
            );
          },
        ),

        // Add Row Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.read<EstimateCubit>().addRow();
                },
                icon: const Chip(avatar: Icon(Icons.add_circle_outline_rounded), label: Text("Add Item")),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text,TextAlign? align, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Theme.of(context).colorScheme.surface,
        ),
        textAlign: align ?? TextAlign.left,
      ),
    );
  }
}