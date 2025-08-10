part of 'balance_cubit.dart';

@immutable
abstract class BalanceState {}

class BalanceInitial extends BalanceState {}


class OrdersLoading extends BalanceState {}

class OrdersLoaded extends BalanceState {
  final List<OrderModel> orders;
  final totalPrice ;

  OrdersLoaded(this.orders, this.totalPrice);
}

class OrdersError extends BalanceState {
  final String message;

  OrdersError(this.message);
}

class BalancesLoading extends BalanceState {}

class BalancesLoaded extends BalanceState {
  final BalancesModel balances;

  BalancesLoaded(this.balances);
}

class BalancesError extends BalanceState {
  final String message;

  BalancesError(this.message);
}