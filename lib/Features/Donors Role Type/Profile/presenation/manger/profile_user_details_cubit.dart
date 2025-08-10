import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/User_Data_Details.dart';

part 'profile_user_details_state.dart';

class ProfileUserDetailsCubit extends Cubit<ProfileUserDetailsState> {
  ProfileUserDetailsCubit() : super(ProfileUserDetailsInitial());

  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDetailsModel? userDetailsModel;

  Future<void> fetchUserDetails(String uid) async {
    try {
      emit(ProfileUserDetailsLoading());

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        // Convert Firestore data to UserDetailsModel
        userDetailsModel = UserDetailsModel.fromJson(doc.data()!);
        emit(ProfileUserDetailsLoaded(userDetailsModel!));
      } else {
        emit(ProfileUserDetailsError('لم يتم العثور على بيانات المستخدم'));
      }
    } catch (e) {
      emit(ProfileUserDetailsError('خطأ في جلب بيانات المستخدم: $e'));
    }
  }

  Future<void> updateUserDetails(
      Map<String, dynamic> updatedData, {
        File? imageFile,
        required String uid, // Made uid required
      }) async {
    try {
      emit(ProfileUserDetailsLoading());

      // Validation
      if (!_validateData(updatedData, imageFile)) {
        return;
      }

      String? imageUrl = updatedData['imageUrl'];
      if (imageFile != null) {
        // Upload image to Supabase Storage
        final fileName =
            '${uid}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        await _supabase.storage.from('storage').upload(fileName, imageFile);
        imageUrl = _supabase.storage.from('storage').getPublicUrl(fileName);
      }

      // Create updated data map using UserDetailsModel structure
      final updateMap = {
        'fullName': updatedData['fullName'] ?? userDetailsModel?.fullName,
        'phoneNumber': updatedData['phoneNumber'] ?? userDetailsModel?.phoneNumber,
        'locationTitle': updatedData['locationTitle'] ?? userDetailsModel?.locationTitle,
        'status': updatedData['status'] ?? userDetailsModel?.status ?? '',
        'uid': uid,
        'userType': updatedData['userType'] ?? userDetailsModel?.userType ?? '',
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Update Firestore
      await _firestore.collection('users').doc(uid).update(updateMap);

      // Fetch updated document and convert to UserDetailsModel
      final updatedDoc = await _firestore.collection('users').doc(uid).get();
      if (updatedDoc.exists) {
        userDetailsModel = UserDetailsModel.fromJson(updatedDoc.data()!);
        emit(ProfileUserDetailsLoaded(userDetailsModel!));
      } else {
        emit(ProfileUserDetailsError('فشل في استرجاع البيانات المحدثة'));
      }
    } catch (e) {
      emit(ProfileUserDetailsError('خطأ في تحديث البيانات: $e'));
    }
  }

  bool _validateData(Map<String, dynamic> data, File? imageFile) {
    // Validate fullName
    if (data['fullName'] == null || data['fullName'].trim().isEmpty) {
      emit(ProfileUserDetailsError('الاسم الكامل مطلوب'));
      return false;
    }
    if (data['fullName'].length < 2) {
      emit(ProfileUserDetailsError('الاسم الكامل يجب أن يكون أطول من حرفين'));
      return false;
    }

    // Validate phoneNumber
    if (data['phoneNumber'] == null || data['phoneNumber'].trim().isEmpty) {
      emit(ProfileUserDetailsError('رقم الهاتف مطلوب'));
      return false;
    }
    final phoneRegExp = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegExp.hasMatch(data['phoneNumber'])) {
      emit(ProfileUserDetailsError('رقم الهاتف غير صالح'));
      return false;
    }

    // Validate locationTitle
    if (data['locationTitle'] == null || data['locationTitle'].trim().isEmpty) {
      emit(ProfileUserDetailsError('عنوان الموقع مطلوب'));
      return false;
    }
    if (data['locationTitle'].length < 3) {
      emit(ProfileUserDetailsError('عنوان الموقع يجب أن يكون أطول من 3 أحرف'));
      return false;
    }

    // Validate image if provided
    if (imageFile != null) {
      final validExtensions = ['jpg', 'jpeg', 'png'];
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!validExtensions.contains(extension)) {
        emit(ProfileUserDetailsError('امتداد الصورة غير مدعوم (jpg, jpeg, png فقط)'));
        return false;
      }
      final fileSizeInMB = imageFile.lengthSync() / (1024 * 1024);
      if (fileSizeInMB > 5) {
        emit( ProfileUserDetailsError('حجم الصورة يجب ألا يتجاوز 5 ميجابايت'));
        return false;
      }
    }

    return true;
  }

  Future<void> pickFile() async {
    try {
      emit(ProfileImagePicking()); // Emit state when starting the file picking process

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'], // Only allow image files
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        emit(ProfileImagePicked(file)); // Emit state with the picked file
      } else {
        emit(ProfileImagePickCancelled()); // Emit state if no file was selected (cancelled)
      }
    } catch (e) {
      emit(ProfileImagePickFailed(e.toString())); // Emit state if an error occurs
    }
  }}