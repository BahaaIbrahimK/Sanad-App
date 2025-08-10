import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/userprofile_model.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  UserProfile? userProfile ;
  // Method to fetch user profile data
  Future<void> fetchUserProfile(uid) async {
    print(uid);
    try {
      emit(ProfileLoading());
      final userData = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userData.exists) {
        emit(ProfileError('User profile not found'));
        return;
      }

       userProfile = UserProfile.fromMap(userData.data()!);
      emit(ProfileLoaded(userProfile!));
    } catch (e) {
      print(e);
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // Pick a file for upload with 10 allowed extensions
  Future<void> pickFile() async {
    try {
      emit(ProfileLoading());
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [ 'pdf', 'jpg', 'png', 'doc', 'docx', 'txt', 'jpeg', 'bmp', 'rtf', 'xls' ],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        emit(ProfileFilePicked(file: file));
      } else {
        emit(const ProfileError('لم يتم اختيار ملف'));
      }
    } catch (e) {
      emit(ProfileError('فشل في اختيار الملف: ${e.toString()}'));
    }
  }

// Upload document to Supabase Storage and update profile in Firebase
  Future<void> uploadDocument(File file, String documentType , uid) async {
    try {
      emit(ProfileUpdating());

      // Upload file to Supabase Storage
      final fileName = '${"*User"}_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      await _supabase.storage.from('storage').upload(fileName, file);

      // Generate the public URL for the uploaded file
      final documentUrl = _supabase.storage.from('storage').getPublicUrl(fileName);
      print(documentUrl);

      // Update Firestore with the document URL and type
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'documents': FieldValue.arrayUnion([
          {
            'linkFile': documentUrl,
            'typeFile': documentType,
          }
        ])
      });

      emit(ProfileUpdateSuccess());
    } catch (e) {
      print(e);
      emit(ProfileError('Failed to upload document: ${e.toString()}'));
    }
  }
  // Method to update user profile
  Future<void> updateUserProfile({
    required String address,
    required String phone,
    required String income,
    required String familySize,
    required String housingDescription,
    required String uid,
  }) async {
    try {
      emit(ProfileUpdating());

      // Create a map with the updated data
      final updatedData = {
        'address': address,
        'phone': phone,
        'income': income,
        'familySize': familySize,
        'housingDescription': housingDescription,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update the user document in Firestore
      await _firestore
          .collection('users')
          .doc(uid)
          .update(updatedData);

      // Fetch the updated profile
      await fetchUserProfile(uid);

      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  // Camera picker
  Future<void> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File file = File(pickedFile.path); // Convert XFile to File
        emit(ProfileFilePicked(file:file));
      }
    } catch (e) {
      emit(ProfileError('Failed to capture image: $e'));
    }
  }

  // Gallery picker
  Future<void> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path); // Convert XFile to File
        emit(ProfileFilePicked(file: file));
      }
    } catch (e) {
      emit(ProfileError('Failed to pick image: $e'));
    }
  }

}
