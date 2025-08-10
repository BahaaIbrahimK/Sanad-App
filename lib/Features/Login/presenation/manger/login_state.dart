part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginAuthenticated extends LoginState {
  final User user;
  final UserDataModel appUser;

  LoginAuthenticated(this.user, {required this.appUser});
}

class LoginAdminAuthenticated extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

class UserNotFound extends LoginState {
  final User user;

  UserNotFound(this.user);
}

class ForgetPasswordLoading extends LoginState {}

class ForgetPasswordOtpSent extends LoginState {}

class ForgetPasswordSuccess extends LoginState {}

class ForgetPasswordError extends LoginState {
  final String message;
  ForgetPasswordError(this.message);
}