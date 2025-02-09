import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final List<EstimateItemsModel> _items = [];
  EstimateBloc() : super(EstimateInitial()) {
    on<LoadItemsEvent>((event, emit) {
      _items.clear();
      try {
        if (_items.isEmpty) {
          _items.add(EstimateItemsModel(
            controller: TextEditingController(),
            quantity: 1,
          ));
        }
        emit(InvoiceItemsLoadedState(List.from(_items)));
      } catch (e) {
        emit(InvoiceItemError(e.toString()));
      }
    });

    on<AddItemEvent>((event, emit) {
      if (event.items.isNotEmpty) {
        _items.add(EstimateItemsModel(
            controller: TextEditingController(), quantity: 1));
        emit(InvoiceItemsLoadedState(List.from(_items)));
      }
    });

    on<RemoveItemEvent>((event, emit) {
      if (event.index > 0 && event.index < _items.length) {
        _items.removeAt(event.index);
        emit(InvoiceItemsLoadedState(List.from(_items)));
      }
    });

    on<UpdateItemEvent>((event, emit) {
      if (event.index >= 0 && event.index < _items.length) {
        // Update the specific item
        _items[event.index] = _items[event.index].copyWith(
          quantity: event.updatedInvoice.quantity,
          amount: event.updatedInvoice.amount,
          discount: event.updatedInvoice.discount,
          tax: event.updatedInvoice.tax,
          total: event.updatedInvoice.total,
          itemId: event.updatedInvoice.itemId,
          itemName: event.updatedInvoice.itemName,
        );
        emit(InvoiceItemsLoadedState(List.from(_items))); // Emit updated list
      }
    });
  }
}
