// donation_state.dart
part of 'donation_cubit.dart';

abstract class DonationState {}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationLoaded extends DonationState {}

class DonationError extends DonationState {
  final String message;

  DonationError(this.message);
}

class DonationLoadedWithCard extends DonationState {
  CreditCard card;
  DonationLoadedWithCard(this.card);
}

class WalletTopUpSuccess extends DonationState {
  final double newBalance;

  WalletTopUpSuccess(this.newBalance);
}

class ProfileUserDetailsLoading extends DonationState {}

class ProfileUserDetailsLoaded extends DonationState {
  final UserDetailsModel userData;
  ProfileUserDetailsLoaded(this.userData);
}

class ProfileUserDetailsError extends DonationState {
  final String error;
  ProfileUserDetailsError(this.error);
}
