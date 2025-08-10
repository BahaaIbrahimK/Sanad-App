import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../Login/data/user_data_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp({
    required String fullName,
    required String locationTitle,
    required String phoneNumber,
    required String password,
    required String userType,
  }) async {
    emit(SignUpLoading());
    try {
      // Step 1: Validate inputs
      if (fullName.isEmpty || locationTitle.isEmpty || phoneNumber.isEmpty || password.isEmpty || userType.isEmpty) {
        emit(SignUpError('All fields are required.'));
        return;
      }

      // Step 2: Validate phone number
      if (!RegExp(r"^\+?[0-9]{10,15}$").hasMatch(phoneNumber)) {
        emit(SignUpError('Please enter a valid phone number with country code (e.g., +1234567890).'));
        return;
      }

      // Step 3: Validate password
      if (password.length < 6) {
        emit(SignUpError('Password must be at least 6 characters long.'));
        return;
      }

      // Step 4: Validate userType
      if (!['Beneficiaries', 'Donors', 'Moderator'].contains(userType)) {
        emit(SignUpError('Invalid user type.'));
        return;
      }

      // Step 5: Create user with Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '$phoneNumber@example.com', // Use phone number as a placeholder email
        password: password,
      );

      // Step 6: Create UserDataModel instance
      final userData = UserDataModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        userType: userType,
        locationTitle: locationTitle,
      );

      // Step 7: Save user details to Firestore
      await _saveUserDetails(userData);

      emit(SignUpAuthenticated(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This phone number is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid phone number format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = e.message ?? 'Sign-up failed. Please try again.';
      }
      emit(SignUpError(errorMessage));
    } catch (e) {
      emit(SignUpError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _saveUserDetails(UserDataModel userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .set(userData.toJson());
  }

  // Logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    emit(SignUpUnauthenticated());
  }
}