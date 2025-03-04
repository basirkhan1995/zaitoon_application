import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:zaitoon_invoice/Json/invoice_model.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());

  final List<InvoiceItems> items = [];

  void updateCurrency(String currency) {
    if (state is LoadedInvoiceItemsState) {
      final currentState = state as LoadedInvoiceItemsState;
      emit(currentState.copyWith(currency: currency));
    }
  }

  void updateVat(String vat) {
    if (state is LoadedInvoiceItemsState) {
      final currentState = state as LoadedInvoiceItemsState;
      emit(currentState.copyWith(vat: vat));
    }
  }

  void updateDiscount(String discount) {
    if (state is LoadedInvoiceItemsState) {
      final currentState = state as LoadedInvoiceItemsState;
      emit(currentState.copyWith(discount: discount));
    }
  }


  Future<void> invoiceLoadedEvent()async{
    try{
      if(items.isEmpty){
        items.add(InvoiceItems(
          controller: TextEditingController(),
          quantity: 1
        ));
      }
      emit(LoadedInvoiceItemsState(List.from(items)));
   }catch(e){
     emit(ErrorInvoiceState(e.toString()));
   }
  }

  Future<void> addItemsEvent()async{
    try{
      if(items.isNotEmpty){
        items.add(InvoiceItems(
          controller: TextEditingController(),
          quantity: 1,
        ));
      }
      emit(LoadedInvoiceItemsState(List.from(items)));
    }catch(e){
      emit(ErrorInvoiceState(e.toString()));
    }
  }

  Future<void> updateItemsEvent({required int index, required InvoiceItems item})async{
    try{
      if(index >= 0 && index < items.length){
        items[index] = items[index].copyWith(
          rowNumber: item.rowNumber,
          itemName: item.itemName,
          quantity: item.quantity,
          amount: item.amount,
          total: item.total,
        );
        emit(LoadedInvoiceItemsState(List.from(items)));
      }
    }catch(e){
      emit(ErrorInvoiceState(e.toString()));
    }
  }

  Future<void> removeItemsEvent({required int index})async{
    try{
      if(items.length > 1 && index < items.length){
        items.removeAt(index);
        emit(LoadedInvoiceItemsState(List.from(items)));
      }
    }catch(e){
      emit(ErrorInvoiceState(e.toString()));
    }
  }




}

