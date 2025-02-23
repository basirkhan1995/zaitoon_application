import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/product_model.dart';
import 'package:zaitoon_invoice/Json/products_report_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final Repositories _repositories;
  ProductsCubit(this._repositories) : super(ProductsInitial());

  Future<void> loadProductsEvent() async {
    try {
      final response = await _repositories.getProductsWithTotalInventory();
      emit(LoadedProductsState(response));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> productsReport(
      {required int productId, required int inventoryId}) async {
    try {
      final res =
          await _repositories.productsReport(inventoryId: 1, productId: 1);
      emit(ReportProductsState(res));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> productSearchingEvent({required String keyword}) async {
    // Load all products when search is performed
    loadProductsEvent();

    try {
      // Perform search when there's a keyword
      final response = await _repositories.searchProducts(keyword);

      // If no results found and keyword is not empty, show error message
      if (response.isEmpty && keyword.isNotEmpty) {
        emit(ProductsErrorState("No item found"));
      }

      // If keyword is empty, load all products
      if (keyword.isEmpty) {
        loadProductsEvent();
      } else {
        emit(LoadedProductsState(response));
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  void resetProductsEvent() => emit(ProductsInitial());

  Future<void> deleteProduct({required int id}) async {
    try {
      await _repositories.deleteProduct(id: id);
      loadProductsEvent();
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> addProductEvent(
      {required String productName,
      required int unit,
      required int category,
      required double buyPrice,
      required double sellPrice,
      required int inventory,
      required int qty}) async {
    try {
      final result = await _repositories.createProduct(
          productName: productName,
          unit: unit,
          category: category,
          buyPrice: buyPrice,
          sellPrice: sellPrice,
          inventory: inventory,
          qty: qty);
      if (result > 0) {
        loadProductsEvent();
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }
}
