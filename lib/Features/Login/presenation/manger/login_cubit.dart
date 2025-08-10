import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sanad/Features/Login/data/user_data_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  UserDataModel? appUser;

  Future<void> login({
    required String phoneNumber,
    required String password,
    bool isAdmin = false,
  }) async {
    emit(LoginLoading());

    try {
      // Step 1: Validate inputs
      if (phoneNumber.isEmpty || password.isEmpty) {
        emit(LoginError('Phone number and password are required.'));
        return;
      }

      // Step 2: Validate phone number format
      if (!RegExp(r"^\+?[0-9]{10,15}$").hasMatch(phoneNumber)) {
        emit(
          LoginError(
            'Invalid phone number format. Use a valid phone number (e.g., +1234567890).',
          ),
        );
        return;
      }

      // Step 3: Validate password strength
      if (password.length < 6) {
        emit(LoginError('Password must be at least 6 characters long.'));
        return;
      }

      // Step 4: Special case for admin login
      if (isAdmin) {
        if (phoneNumber == "01111111111" && password == "123456As") {
          emit(LoginAdminAuthenticated()); // Emit admin authenticated state
          return;
        } else {
          emit(LoginError('Invalid admin credentials.'));
          return;
        }
      }

      // Step 5: Attempt Firebase Authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email:
            '$phoneNumber@example.com', // Still using this mapping as per your original code
        password: password,
      );

      // Step 6: Fetch user data from Firestore
      final firestore = FirebaseFirestore.instance;
      final userDoc =
          await firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        // Step 7: User exists, map Firestore data to AppUser
        appUser = UserDataModel.fromJson(
          userDoc.data() as Map<String, dynamic>,
        );
      } else {
        // Step 8: User not found in Firestore, emit UserNotFound state
        print('User not found in Firestore');
        emit(UserNotFound(userCredential.user!));
        return;
      }

      // Step 9: Emit authenticated state with user data
      emit(LoginAuthenticated(userCredential.user!, appUser: appUser!));
    } on FirebaseAuthException catch (e) {
      // Step 10: Handle Firebase-specific errors
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this phone number.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid phone number format.';
          break;
        default:
          errorMessage = e.message ?? 'Login failed. Please try again.';
      }
      emit(LoginError(errorMessage));
    } catch (e) {
      // Step 11: Handle any other unexpected errors
      emit(LoginError('An unexpected error occurred: $e'));
    }
  }

  // Verify OTP and reset password
  Future<void> verifyOtpAndResetPassword({
    required String otp,
    required String newPassword,
  }) async {
    emit(ForgetPasswordLoading());
    try {
      // Validate input
      if (otp.isEmpty || newPassword.isEmpty) {
        emit(ForgetPasswordError('OTP and new password are required.'));
        return;
      }

      if (newPassword.length < 6) {
        emit(
          ForgetPasswordError('Password must be at least 6 characters long.'),
        );
        return;
      }

      // Create a PhoneAuthCredential with the OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      // Sign in with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Update the user's password
      await userCredential.user!.updatePassword(newPassword);

      emit(ForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        ForgetPasswordError(
          e.message ?? 'Failed to verify OTP or reset password.',
        ),
      );
    } catch (e) {
      emit(ForgetPasswordError('An error occurred: $e'));
    }
  }
}
