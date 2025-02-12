import 'package:equatable/equatable.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

class EstimateState extends Equatable {
  final List<EstimateItemsModel> items;

  const EstimateState({required this.items});

  @override
  List<Object> get props => [items];
}
