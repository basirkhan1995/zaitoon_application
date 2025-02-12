import 'package:flutter/material.dart';
import '../../../../../Json/z_estimate.dart';

class EstimateRow extends StatelessWidget {
  final ZEstimateModel row;
  final Function(ZEstimateModel) onChanged;
  final VoidCallback onRemove;

  const EstimateRow({
    super.key,
    required this.row,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              color: Colors.grey.withOpacity(.2),
              width: 1), // Table border outline
          inside: BorderSide.none, // No internal borders
        ),
        children: [
          TableRow(
            children: [
              // Row Number
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  row.rowNumber.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildTextField('Item Name', row.itemName, (value) {
                onChanged(row.copyWith(itemName: value));
              }),
              _buildTextField('Qty', row.quantity.toString(), (value) {
                final quantity = int.tryParse(value) ?? 0;
                onChanged(row.copyWith(quantity: quantity));
              }),
              _buildTextField('Amount', row.amount.toString(), (value) {
                final amount = double.tryParse(value) ?? 0.0;
                onChanged(row.copyWith(amount: amount));
              }),
              _buildTextField('Tax', row.tax.toString(), (value) {
                final tax = double.tryParse(value) ?? 0.0;
                onChanged(row.copyWith(tax: tax));
              }),
              _buildTextField('Discount', row.discount.toString(), (value) {
                final discount = double.tryParse(value) ?? 0.0;
                onChanged(row.copyWith(discount: discount));
              }),

              _buildTextField('Total', (row.amount * row.quantity + row.tax - row.discount).toStringAsFixed(2), (value) {
                final discount = double.tryParse(value) ?? 0.0;
                onChanged(row.copyWith(discount: discount));
              }),

              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
        onChanged: onChanged,
      ),
    );
  }
}