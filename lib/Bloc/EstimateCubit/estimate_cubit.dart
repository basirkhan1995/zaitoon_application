import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Json/z_estimate.dart';

class EstimateCubit extends Cubit<List<ZEstimateModel>> {
  EstimateCubit() : super([ZEstimateModel(rowNumber: 1)]);

  void addRow() {
    final newRowNumber = state.last.rowNumber! + 1;
    final newRow = ZEstimateModel(rowNumber: newRowNumber);
    emit([...state, newRow]);
  }

  void removeRow(int rowNumber) {
    if (state.length > 1) {
      final updatedList =
          state.where((row) => row.rowNumber != rowNumber).toList();
      emit(updatedList);
    }
  }

  void updateRow(ZEstimateModel updatedRow) {
    final updatedList = state.map((row) {
      return row.rowNumber == updatedRow.rowNumber ? updatedRow : row;
    }).toList();
    emit(updatedList);
  }

  // VAT value
  double vatValue = 15.0;

  // Method to update VAT value
  void updateVat(double newVat) {
    vatValue = newVat;
    emit([...state]); // Triggers the update in the UI
  }

  // Calculate VAT
  double calculateVAT() {
    return calculateSubtotal() * (vatValue / 100);
  }

  // Calculate Subtotal
  double calculateSubtotal() {
    // Calculate the subtotal from the rows
    return state.fold(
        0.0, (subtotal, row) => subtotal + (row.quantity * row.amount));
  }

  // Calculate total
  double calculateTotal() {
    return calculateSubtotal() + calculateVAT();
  }
}
