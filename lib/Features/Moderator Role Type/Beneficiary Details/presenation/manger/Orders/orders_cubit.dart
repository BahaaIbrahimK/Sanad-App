import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../../../data/order_model.dart';
import '../../../data/user_model.dart';
import 'orders_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrderCubit() : super(OrderInitial());

  // Fetch all beneficiaries from Firestore
  Future<void> fetchBeneficiaries() async {
    emit(BeneficiariesLoading()); // Emit loading state

    try {
      // Fetch all documents where userType is "Beneficiaries"
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'Beneficiaries')
          .get(GetOptions(source: Source.server));

      // Convert each document to a UserModel and create a list
      List<UserProfile> beneficiaries =
          querySnapshot.docs
              .map(
                (doc) =>
                    UserProfile.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList();

      // Emit the loaded state with the list of beneficiaries
      emit(BeneficiariesLoaded(beneficiaries));
    } catch (e) {
      // Emit error state if an exception occurs
      emit(BeneficiariesError('Failed to fetch beneficiaries: $e'));
    }
  }

  Future<void> updateBeneficiaryStatus(String userId, String newStatus ,monthlyAmount) async {
    print(monthlyAmount);
    // Validate newStatus
    if (newStatus != 'Accept' && newStatus != 'Reject') {
      throw Exception('Status must be either "Accept" or "Reject"');
    }

    emit(BeneficiaryLoading()); // Emit loading state

    try {
      // Reference to the specific user document
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Update the status field
      await userRef.update({
        'status': newStatus,
        'monthlyAmount':monthlyAmount,
        'updatedAt':
            FieldValue.serverTimestamp(), // Optional: track when it was updated
      });

      // Emit the updated state
      emit(BeneficiaryLoaded());
    } catch (e) {
      // Emit error state if an exception occurs
      emit(BeneficiaryError('Failed to update beneficiary status: $e'));
    }
  }

  Future<void> updateOrderDetails(UserProfile user, String newTypeFile) async {
    try {
      emit(OrderDetailsLoading());

      // Fetch the current document from Firestore
      final doc = await _firestore.collection('users').doc(user.id).get();
      if (!doc.exists) {
        emit(OrderDetailsError('Order not found'));
        return;
      }

      // Get the existing documents array (with typeFile and linkFile)
      final existingDocs = (doc.data()!['documents'] as List<dynamic>?)
          ?.map((doc) => Map<String, String>.from(doc))
          .toList() ??
          [];

      // Add the new item with only typeFile
      existingDocs.add({'typeFile': newTypeFile});

      // Prepare the updated data
      final updateData = user.toMap();
      updateData['documents'] = existingDocs;

      // Update Firestore
      await _firestore.collection('users').doc(user.id).update(updateData);
      emit(OrderDetailsLoaded(user.copyWith(documents: existingDocs)));
    } catch (e) {
      emit(OrderDetailsError('Failed to update order: $e'));
    }
  }
  // Send notification (assuming a notifications collection)
  Future<void> sendNotification(String uid, String message) async {
    emit(OrderDetailsNotificationLoading());
    try {
      await _firestore
          .collection('notifications')
          .doc(uid)
          .collection("user_notifications")
          .add({
            'uid': uid,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
          });
      emit(OrderDetailsNotificationSent());
    } catch (e) {
      emit(OrderDetailsNotificationError('Failed to send notification: $e'));
    }
  }
}
