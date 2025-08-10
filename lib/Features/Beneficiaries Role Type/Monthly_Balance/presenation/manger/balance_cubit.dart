import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../Assessment/data/beneficiary_model.dart';
import '../../data/Balances_Model.dart';
import '../../data/Order_Model.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchBalances(String userId) async {
    emit(BalancesLoading()); // Emit loading state

    try {
      DocumentSnapshot doc =
          await _firestore.collection('balance').doc(userId).get();
      if (doc.exists) {
        final balances = BalancesModel.fromJson(
          doc.data() as Map<String, dynamic>,
        );
        emit(BalancesLoaded(balances)); // Emit loaded state with data
      } else {
        emit(BalancesError("Balance data not found")); // Emit error state
      }
    } catch (e) {
      emit(BalancesError("Failed to fetch balances: $e")); // Emit error state
    }
  }

   double totalPrice = 0;
  // Function to fetch orders for a specific user
  Future<void> fetchOrders(String userId) async {
    emit(OrdersLoading()); // Emit loading state

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('orders').doc(userId).collection("user_orders").get();

      final orders =
          querySnapshot.docs
              .map(
                (doc) =>
                    OrderModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      // Calculate total number of orders
      final totalOrders = orders.length;

      // Calculate the total sum of prices
      totalPrice = orders.fold(0.0, (sum, order) => sum + order.amount);

      print("Orders: $orders");
      print("Total Price: $totalPrice");


      print(orders);
      emit(OrdersLoaded(orders ,totalPrice)); // Emit loaded state with data
    } catch (e) {
      emit(OrdersError("Failed to fetch orders: $e")); // Emit error state
    }
  }
}
