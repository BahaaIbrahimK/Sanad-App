import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../data/pharmacy_model.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(PharmacyInitial());


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getPharmacies() async {
    emit(PharmacyLoadingState());
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('pharmacies').get();

      List<PharmacyModel> pharmacies = querySnapshot.docs.map((doc) {
        return PharmacyModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PharmacyLoadedState(pharmacies));
    } catch (e) {
      emit(PharmacyErrorState("فشل تحميل البيانات: ${e.toString()}"));
    }
  }

}
