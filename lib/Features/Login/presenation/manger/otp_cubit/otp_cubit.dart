import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OtpCubit() : super(OtpInitial());

  // Send OTP to the user's phone number
  Future<void> sendOtp(String phoneNumber) async {
    emit(OtpLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user if verification is completed
          await _auth.signInWithCredential(credential);
          emit(OtpVerified());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(OtpError(e.message ?? "فشل إرسال رمز التحقق"));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(OtpSent(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed
        },
      );
    } catch (e) {
      emit(OtpError("حدث خطأ أثناء إرسال رمز التحقق"));
    }
  }

  // Verify the OTP entered by the user
  Future<void> verifyOtp(String verificationId, String otp) async {
    emit(OtpLoading());
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      emit(OtpVerified());
    } catch (e) {
      emit(OtpError("رمز التحقق غير صحيح"));
    }
  }
}