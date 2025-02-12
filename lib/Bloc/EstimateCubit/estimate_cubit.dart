import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';
import 'estimate_state.dart';

class EstimateCubit extends Cubit<EstimateState> {
  EstimateCubit()
      : super(EstimateState(items: [
          EstimateItemsModel(rowNumber: 1), // Default row
        ]));

  void addRow() {
    final newRowNumber = state.items.length + 1;
    final newItem = EstimateItemsModel(rowNumber: newRowNumber);
    final updatedItems = List<EstimateItemsModel>.from(state.items)
      ..add(newItem);
    emit(EstimateState(items: updatedItems));
  }

  void updateRow(int index, EstimateItemsModel updatedItem) {
    final updatedItems = List<EstimateItemsModel>.from(state.items);
    updatedItems[index] = updatedItem;
    emit(EstimateState(items: updatedItems));
  }
}
