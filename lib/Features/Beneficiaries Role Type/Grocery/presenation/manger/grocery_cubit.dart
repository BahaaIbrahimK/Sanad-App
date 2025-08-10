import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../data/grocery_model.dart';

part 'grocery_state.dart';

class GroceryCubit extends Cubit<GroceryState> {
  GroceryCubit() : super(GroceryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch grocery data
  Future<void> fetchGroceries() async {
    emit(GroceryLoading()); // Emit loading state

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('groceries').get();
      final groceries = querySnapshot.docs
          .map((doc) => GroceryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      emit(GroceryLoaded(groceries)); // Emit loaded state with data
    } catch (e) {
      print(e);
      emit(GroceryError("Failed to fetch groceries: $e")); // Emit error state
    }
  }

}
