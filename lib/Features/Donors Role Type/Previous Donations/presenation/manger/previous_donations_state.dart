part of 'previous_donations_cubit.dart';

@immutable
abstract class PreviousDonationsState {}

class PreviousDonationsInitial extends PreviousDonationsState {}

class BeneficiariesLoading extends PreviousDonationsState {}

class BeneficiariesError extends PreviousDonationsState {
  final String message;

  BeneficiariesError(this.message);
}

class TransactionLoading extends PreviousDonationsState {}

class TransactionLoaded extends PreviousDonationsState {
  final List<TransactionModel> transactions;

  TransactionLoaded(this.transactions);
}

class BeneficiariesLoaded extends PreviousDonationsState {
  final List<UserProfile> beneficiaries;
  BeneficiariesLoaded(this.beneficiaries);
}

class TransactionError extends PreviousDonationsState {
  final String message;

  TransactionError(this.message);
}
