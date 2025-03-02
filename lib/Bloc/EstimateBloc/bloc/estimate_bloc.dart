import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final List<EstimateItemsModel> items = [];
  EstimateBloc() : super(EstimateInitial()) {
    double tax = 0.0;
    double discount = 0.0;

    on<UpdateTaxEvent>((event, emit) {
      tax = event.tax;
      emit(EstimateItemsLoadedState(
          items.map((item) => item.copyWith(tax: tax)).toList()));
    });

    on<UpdateDiscountEvent>((event, emit) {
      discount = event.discount;
      emit(EstimateItemsLoadedState(List.from(items)));
    });

    on<UpdateTaxEvent>((event, emit) {
      emit(EstimateItemsLoadedState(
          items.map((item) => item.copyWith(tax: event.tax)).toList()));
    });
    on<LoadItemsEvent>((event, emit) {
      items.clear();
      try {
        if (items.isEmpty) {
          items.add(EstimateItemsModel(
            controller: TextEditingController(),
            quantity: 1,
          ));
        }
        emit(EstimateItemsLoadedState(List.from(items)));
      } catch (e) {
        emit(EstimateItemError(e.toString()));
      }
    });

    on<AddItemEvent>((event, emit) {
      if (event.items.isNotEmpty) {
        items.add(EstimateItemsModel(
            controller: TextEditingController(), quantity: 1));
        emit(EstimateItemsLoadedState(List.from(items)));
      }
    });

    on<RemoveItemEvent>((event, emit) {
      if (event.index > 0 && event.index < items.length) {
        items.removeAt(event.index);
        emit(EstimateItemsLoadedState(List.from(items)));
      }
    });

    on<UpdateItemEvent>((event, emit) {
      if (event.index >= 0 && event.index < items.length) {
        // Update the specific item
        items[event.index] = items[event.index].copyWith(
          quantity: event.updatedInvoice.quantity,
          amount: event.updatedInvoice.amount,
          discount: event.updatedInvoice.discount,
          tax: event.updatedInvoice.tax,
          total: event.updatedInvoice.total,
          itemName: event.updatedInvoice.itemName,
        );
        emit(EstimateItemsLoadedState(List.from(items))); // Emit updated list
      }
    });
  }
}
