part of 'otp_cubit.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSent extends OtpState {
  final String verificationId;
  OtpSent(this.verificationId);
}

class OtpVerified extends OtpState {}

class OtpError extends OtpState {
  final String message;
  OtpError(this.message);
}