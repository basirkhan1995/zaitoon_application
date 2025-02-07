part of 'currency_cubit.dart';

sealed class CurrencyState extends Equatable {
  const CurrencyState();
}

final class CurrencyInitial extends CurrencyState {
  @override
  List<Object> get props => [];
}

final class CurrencyErrorState extends CurrencyState{
  final String error;
  const CurrencyErrorState(this.error);
  @override
  List<Object> get props => [error];
}

final class LoadedCurrencyState extends CurrencyState{
  final List<CurrenciesModel> currencies;
  const LoadedCurrencyState(this.currencies);
  @override
  List<Object> get props => [currencies];
}