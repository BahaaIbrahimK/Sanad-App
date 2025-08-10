import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/manger/profile/profile_state.dart';

import '../../../data/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileCubit() : super(ProfileInitial());

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    emit(ProfileLoading()); // Emit loading state

    try {
      // Fetch the document for the given userId
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc("niSy9QiK4OPL3EQRzaxwKLtHZu53").get(
        GetOptions(source: Source.server)
      );

      if (userDoc.exists) {
        // Convert Firestore data to a Map
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Convert the Map to UserModel
        UserModel user = UserModel.fromJson(userData.cast<String, String>());

        // Emit the loaded state with user data
        emit(ProfileLoaded(user));

        print(user.phoneNumber);
      } else {
        // Emit error state if the user does not exist
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      print(e.toString());
      // Emit error state if an exception occurs
      emit(ProfileError('Failed to fetch user data: $e'));
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(String userId, UserModel updatedUser) async {
    emit(ProfileLoading()); // Emit loading state

    try {
      // Convert UserModel to a Map
      Map<String, dynamic> updatedData = updatedUser.toJson();

      // Update the document in Firestore
      await _firestore.collection('users').doc(userId).update(updatedData);

      // Emit the updated state with the updated user data
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      // Emit error state if an exception occurs
      emit(ProfileError('Failed to update user data: $e'));
    }
  }
}