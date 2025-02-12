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
      final updatedList = state.where((row) => row.rowNumber != rowNumber).toList();
      emit(updatedList);
    }
  }

  void updateRow(ZEstimateModel updatedRow) {
    final updatedList = state.map((row) {
      return row.rowNumber == updatedRow.rowNumber ? updatedRow : row;
    }).toList();
    emit(updatedList);
  }

  // Calculate Subtotal
  double calculateSubtotal() {
    return state.fold(0, (sum, row) => sum + (row.amount * row.quantity));
  }

  // Calculate VAT (e.g., 15%)
  double calculateVAT() {
    return calculateSubtotal() * 0.15;
  }

  // Calculate Total (Subtotal + VAT)
  double calculateTotal() {
    return calculateSubtotal() + calculateVAT();
  }

}