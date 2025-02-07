import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Json/product_category.dart';

part 'product_category_state.dart';

class ProductCategoryCubit extends Cubit<ProductCategoryState> {
  final Repositories _repositories;
  ProductCategoryCubit(this._repositories) : super(ProductCategoryInitial());

  Future<void> loadProductCategoryEvent()async{
    try{
      final categories = await _repositories.getProductCategories();
      emit(LoadedProductsCategoryState(categories));
    }catch(e){
      emit(ProductCategoryErrorState(e.toString()));
    }
  }

 }
