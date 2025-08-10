import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../Profile/data/userprofile_model.dart';
import '../../data/beneficiary_model.dart';

part 'beneficiary_state.dart';

class BeneficiaryCubit extends Cubit<BeneficiaryState> {
  BeneficiaryCubit() : super(BeneficiaryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fetch function using UserProfile model
  Future<void> fetchUserData(String userId) async {
    emit(UserLoading()); // Emit loading state

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final user = UserProfile.fromMap(doc.data() as Map<String, dynamic>);
        emit(UserLoaded(user)); // Emit loaded state with UserProfile
      } else {
        emit(UserError("User data not found")); // Emit error state
      }
    } catch (e) {
      emit(UserError("Failed to fetch user data: $e")); // Emit error state
    }
}
}
