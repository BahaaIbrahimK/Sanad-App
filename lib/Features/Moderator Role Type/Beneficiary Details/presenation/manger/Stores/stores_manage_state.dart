import 'dart:io';

abstract class StoresManageState {}

class StoresManageInitial extends StoresManageState {}

class StoresManageLoading extends StoresManageState {}

class StoresManageError extends StoresManageState {
  final String error;

  StoresManageError(this.error);
}

class StoresManageImagePickedSuccess extends StoresManageState {
  final File? image;
  final String? imageUrl;

  StoresManageImagePickedSuccess({this.image, this.imageUrl});
}

class StoresManageImagePickedLoading extends StoresManageState {}

class StoresManageImageReplacedSuccess extends StoresManageState {
  final String storeId;
  final String newImageUrl;
  final String message;

  StoresManageImageReplacedSuccess({
    required this.storeId,
    required this.newImageUrl,
    required this.message,
  });
}

class StoresManageStoreTypeChanged extends StoresManageState {
  final String storeType;

  StoresManageStoreTypeChanged(this.storeType);
}

class StoresManageAddStoreSuccess extends StoresManageState {
  final String message;

  StoresManageAddStoreSuccess(this.message);
}

class StoresManageFetchStoresSuccess extends StoresManageState {
  final List stores;

  StoresManageFetchStoresSuccess(this.stores);
}

class StoresManageUpdateStoreSuccess extends StoresManageState {
  final String message;

  StoresManageUpdateStoreSuccess(this.message);
}

class StoresManageDeleteStoreSuccess extends StoresManageState {
  final String message;

  StoresManageDeleteStoreSuccess(this.message);
}