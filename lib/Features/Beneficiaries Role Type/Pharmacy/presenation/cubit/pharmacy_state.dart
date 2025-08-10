part of 'pharmacy_cubit.dart';

abstract class PharmacyState {
  const PharmacyState();

  @override
  List<Object> get props => [];
}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoadingState extends PharmacyState {}

class PharmacyLoadedState extends PharmacyState {
  final List<PharmacyModel> pharmacies;

  const PharmacyLoadedState(this.pharmacies);

  @override
  List<Object> get props => [pharmacies];
}

class PharmacyErrorState extends PharmacyState {
  final String message;

  const PharmacyErrorState(this.message);

  @override
  List<Object> get props => [message];
}
