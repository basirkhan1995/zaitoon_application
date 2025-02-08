import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Json/estimate.dart';

part 'estimate_state.dart';

class EstimateCubit extends Cubit<EstimateState> {
  EstimateCubit() : super(EstimateInitial());


}
