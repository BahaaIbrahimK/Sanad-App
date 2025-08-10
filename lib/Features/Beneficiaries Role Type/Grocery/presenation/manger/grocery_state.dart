part of 'grocery_cubit.dart';

@immutable
abstract class GroceryState {}

class GroceryInitial extends GroceryState {}

class GroceryLoading extends GroceryState {}

class GroceryLoaded extends GroceryState {
  final List<GroceryModel> groceries;

  GroceryLoaded(this.groceries);
}

class GroceryError extends GroceryState {
  final String message;

  GroceryError(this.message);
}