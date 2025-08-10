part of 'profile_user_details_cubit.dart';

@immutable
abstract class ProfileUserDetailsState {}

class ProfileUserDetailsInitial extends ProfileUserDetailsState {}

class ProfileUserDetailsLoading extends ProfileUserDetailsState {}

class ProfileUserDetailsLoaded extends ProfileUserDetailsState {
 final  UserDetailsModel userData;
  ProfileUserDetailsLoaded(this.userData);
}

class ProfileUserDetailsError extends ProfileUserDetailsState {
  final String error;
  ProfileUserDetailsError(this.error);
}

// New states for pickFile function
class ProfileImagePicking extends ProfileUserDetailsState {
  // Indicates that the file picker is being opened and the process has started
}

class ProfileImagePicked extends ProfileUserDetailsState {
  final File imageFile;
   ProfileImagePicked(this.imageFile);
}

class ProfileImagePickCancelled extends ProfileUserDetailsState {
  // When the user cancels the file picking process
   ProfileImagePickCancelled();
}

class ProfileImagePickFailed extends ProfileUserDetailsState {
  final String error;
   ProfileImagePickFailed(this.error);
}