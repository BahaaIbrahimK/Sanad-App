// donation_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Profile/data/User_Data_Details.dart';
import '../../data/credit_card_model.dart';

part 'donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Local wallet balance, initialized with a starting value
  double walletBalance = 5000.0; // You can set any initial value you prefer

  DonationCubit() : super(DonationInitial());

  UserDetailsModel? userDetailsModel;
  Future<void> fetchUserDetails(String uid) async {
    try {
      emit(ProfileUserDetailsLoading());

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        // Convert Firestore data to UserDetailsModel
        final userDetails = UserDetailsModel.fromJson(doc.data()!);
        userDetailsModel = userDetails; // Update the class-level variable
        emit(ProfileUserDetailsLoaded(userDetails));
      } else {
        emit(ProfileUserDetailsError('لم يتم العثور على بيانات المستخدم'));
      }
    } catch (e) {
      emit(ProfileUserDetailsError('خطأ في جلب بيانات المستخدم: $e'));
    }
  }


  Future<void> topUpWallet(double amount, String uid) async {
    try {
      if (amount <= 0) {
        emit(DonationError('المبلغ يجب أن يكون أكبر من صفر'));
        return;
      }

      emit(DonationLoading());

      // Update local wallet balance
      walletBalance -= amount;

      // Optional: Log the transaction in Firestore without affecting wallet balance there
      await _firestore.collection('transactions').add({
        'user_id': uid,
        'amount': amount,
        'type': 'top_up',
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(WalletTopUpSuccess(walletBalance));
    } catch (e) {
      emit(DonationError('فشل في شحن المحفظة: $e'));
    }
  }

// Save credit card details
  Future<void> saveCreditCard({
    required CreditCard creditCard,
    required String uid,
  }) async {
    try {
      emit(DonationLoading());

      if (creditCard.cardNumber.isEmpty ||
          creditCard.expiryDate.isEmpty ||
          creditCard.cvv.isEmpty) {
        emit(DonationError('يرجى ملء جميع الحقول'));
        return;
      }

      await _firestore.collection('credit_cards').doc(uid).set(
        creditCard.toJson(),
        SetOptions(merge: true),
      );

      emit(DonationLoaded());
    } catch (e) {
      emit(DonationError('فشل في حفظ بيانات البطاقة: $e'));
    }
  }

  CreditCard? creditCard;
// Get credit card details
  Future<void> getCreditCard({required String uid}) async {
    try {
      emit(DonationLoading());

      DocumentSnapshot doc = await _firestore.collection('credit_cards').doc(uid).get();

      if (doc.exists) {
        creditCard = CreditCard.fromJson(doc.data() as Map<String, dynamic>);
        print(creditCard);
        emit(DonationLoadedWithCard(creditCard!));
      } else {
        emit(DonationError('لم يتم العثور على بيانات البطاقة'));
      }

    } catch (e) {
      emit(DonationError('فشل في جلب بيانات البطاقة: $e'));
    }
  }


  // Getter to access wallet balance
  double get currentWalletBalance => walletBalance;

}