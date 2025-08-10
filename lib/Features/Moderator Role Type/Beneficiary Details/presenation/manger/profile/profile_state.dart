
import '../../../data/user_model.dart';


abstract class ProfileState {}

// Initial state
class ProfileInitial extends ProfileState {}

// Loading state (e.g., when fetching or updating data)
class ProfileLoading extends ProfileState {}

// State when user data is successfully fetched
class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);
}

// State when user data is successfully updated
class ProfileUpdated extends ProfileState {
  final UserModel updatedUser;

  ProfileUpdated(this.updatedUser);
}

// State when an error occurs
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}