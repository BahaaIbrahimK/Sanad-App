import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

import '../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../../data/Transaction.dart';

part 'previous_donations_state.dart';

class PreviousDonationsCubit extends Cubit<PreviousDonationsState> {
  PreviousDonationsCubit() : super(PreviousDonationsInitial());

  Future<void> fetchTransactions(uid) async {
    try {
      emit(TransactionLoading());

      // Fetch transactions from Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions').where("user_id", isEqualTo: uid)
          .get();

      final transactions = snapshot.docs.map((doc) {
        return TransactionModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError('Failed to fetch transactions: $e'));
    }
  }


  Future<void> fetchBeneficiaries() async {
    emit(BeneficiariesLoading()); // Emit loading state

    try {
      // Fetch documents where userType is "Beneficiaries" and status is "new"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'Beneficiaries')
          .where('status', isEqualTo: 'Accept')
          .get(GetOptions(source: Source.server));

      // Convert each document to a UserProfile and create a list
      List<UserProfile> beneficiaries = querySnapshot.docs
          .map(
            (doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>),
      )
          .toList();

      // Emit the loaded state with the list of beneficiaries
      emit(BeneficiariesLoaded(beneficiaries));
    } catch (e) {
      // Emit error state if an exception occurs
      emit(BeneficiariesError('Failed to fetch beneficiaries: $e'));
    }
  }


  
}
