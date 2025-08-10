part of 'beneficiary_cubit.dart';

@immutable
abstract class BeneficiaryState {}

class BeneficiaryInitial extends BeneficiaryState {}

class UserLoading extends BeneficiaryState {}

class UserLoaded extends BeneficiaryState {
  final UserProfile user;
  UserLoaded(this.user);
}

class UserError extends BeneficiaryState {
  final String message;
  UserError(this.message);
}