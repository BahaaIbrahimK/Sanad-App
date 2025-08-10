import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/manger/Stores/stores_manage_state.dart';

import '../../../data/store_model.dart';
import 'package:http/http.dart' as http;

class StoresManageCubit extends Cubit<StoresManageState> {
  final FirebaseFirestore _firestore;
  final ImagePicker _imagePicker;

  StoresManageCubit({
    FirebaseFirestore? firestore,
    ImagePicker? imagePicker,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(StoresManageInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          // For web, convert the image to bytes and upload it
          final bytes = await pickedFile.readAsBytes();
          final imageUrl = await _uploadImageToImgBBWeb(bytes);
          emit(StoresManageImagePickedSuccess(imageUrl: imageUrl));
        } else {
          // For mobile, use the File object
          final File file = File(pickedFile.path);
          emit(StoresManageImagePickedSuccess(image: file));
        }
      }
    } catch (e) {
      emit(StoresManageError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> pickAndReplaceImage(String storeId) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(StoresManageLoading());

        if (kIsWeb) {
          // For web, convert the image to bytes and replace
          final bytes = await pickedFile.readAsBytes();
          await replaceDefaultImage(storeId, imageBytes: bytes);
        } else {
          // For mobile, use the File object
          final File file = File(pickedFile.path);
          await replaceDefaultImage(storeId, imageFile: file);
        }
      }
    } catch (e) {
      emit(StoresManageError('Failed to pick replacement image: ${e.toString()}'));
    }
  }

  Future<void> replaceDefaultImage(String storeId, {File? imageFile, Uint8List? imageBytes}) async {
    try {
      String? imageUrl;

      // Upload the new image
      if (kIsWeb && imageBytes != null) {
        imageUrl = await _uploadImageToImgBBWeb(imageBytes);
      } else if (imageFile != null) {
        imageUrl = await uploadImageToImgBB(imageFile);
      }

      if (imageUrl != null) {
        // Update the store document with the new image URL
        await _firestore.collection('stores').doc(storeId).update({
          'imageUrl': imageUrl
        });

        emit(StoresManageImageReplacedSuccess(
            storeId: storeId,
            newImageUrl: imageUrl,
            message: 'Store image updated successfully'
        ));
      } else {
        emit(StoresManageError('Failed to upload new image'));
      }
    } catch (e) {
      emit(StoresManageError('Failed to replace image: ${e.toString()}'));
    }
  }

  Future<String?> uploadImageToImgBB(File imageFile) async {
    emit(StoresManageImagePickedLoading());
    const String apiKey = '74c072c66bf0ca09c4c25e68d5fcf276'; // Replace with your ImgBB API key
    final uri = Uri.parse('https://api.imgbb.com/1/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        if (jsonResponse['data'] != null && jsonResponse['data']['url'] != null) {
          return jsonResponse['data']['url']; // Return the uploaded image URL
        }
      }
      throw Exception('Failed to upload image');
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }

  Future<String?> _uploadImageToImgBBWeb(Uint8List imageBytes) async {
    const String apiKey = '74c072c66bf0ca09c4c25e68d5fcf276'; // Replace with your ImgBB API key
    final uri = Uri.parse('https://api.imgbb.com/1/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['key'] = apiKey
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        if (jsonResponse['data'] != null && jsonResponse['data']['url'] != null) {
          return jsonResponse['data']['url']; // Return the uploaded image URL
        }
      }
      throw Exception('Failed to upload image');
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }

  void changeStoreType(String storeType) {
    emit(StoresManageStoreTypeChanged(storeType));
  }


  Future<void> addStore({
    required String storeName,
    required String storeLocation,
    required String storeType,
    String? storeImage,
  }) async {
    emit(StoresManageLoading());

    try {

      // Determine the Firestore collection
      String collectionName;
      if (storeType == 'صيدليه') {
        collectionName = 'pharmacies';
      } else if (storeType == 'بقاله') {
        collectionName = 'groceries';
      } else {
        collectionName = 'stores'; // Default collection
      }

      // Fetch latitude and longitude from the address
      double? latitude;
      double? longitude;

      try {
        List<Location> locations = await locationFromAddress(storeLocation);
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        }
      } catch (geoError) {
        print('Failed to get lat/long: $geoError');
        emit(StoresManageError('Failed to get store coordinates.'));
        return;
      }

      // Create store model with lat & long
      final store = StoreModel(
        storeName: storeName,
        storeLocation: storeLocation,
        storeType: storeType,
        imageUrl: storeImage,
        latitude: latitude,
        longitude: longitude,
      );

      // Add store to the appropriate Firestore collection
      _firestore.collection(collectionName).add(store.toJson());

      emit(StoresManageAddStoreSuccess(
          'Store added successfully to $collectionName'));
    } catch (e) {
      emit(StoresManageError('Failed to add store: ${e.toString()}'));
    }
  }

  // Additional methods can be added here for store management
  Future<List<StoreModel>> fetchStores() async {
    try {
      final querySnapshot = await _firestore.collection('stores').get();

      return querySnapshot.docs.map((doc) =>
          StoreModel.fromJson(doc.data(), id: doc.id)
      ).toList();
    } catch (e) {
      emit(StoresManageError('Failed to fetch stores: ${e.toString()}'));
      return [];
    }
  }

  Future<void> updateStore(StoreModel store) async {
    try {
      await _firestore.collection('stores').doc(store.id).update(store.toJson());
      emit(StoresManageAddStoreSuccess('Store updated successfully'));
    } catch (e) {
      emit(StoresManageError('Failed to update store: ${e.toString()}'));
    }
  }

  Future<void> deleteStore(String storeId) async {
    try {
      await _firestore.collection('stores').doc(storeId).delete();
      emit(StoresManageAddStoreSuccess('Store deleted successfully'));
    } catch (e) {
      emit(StoresManageError('Failed to delete store: ${e.toString()}'));
    }
  }
}