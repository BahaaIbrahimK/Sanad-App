part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}

class AuthInitial extends SignUpState {}

class AuthLoading extends SignUpState {}

class SignUpCodeSent extends SignUpState {
  final String verificationId;
  final int? resendToken;

   SignUpCodeSent(this.verificationId, this.resendToken);

  List<Object> get props => [verificationId, resendToken ?? 0];
}

class SignUpAuthenticated extends SignUpState {
  final User user;

   SignUpAuthenticated(this.user);

  List<Object> get props => [user];
}

class SignUpUnauthenticated extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;

   SignUpError(this.message);

  List<Object> get props => [message];
}