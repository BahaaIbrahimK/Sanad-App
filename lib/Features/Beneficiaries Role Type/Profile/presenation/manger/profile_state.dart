// part of 'profile_cubit.dart'
part of 'profile_cubit.dart';

// Base state class
abstract class ProfileState {
  const ProfileState();

  List<Object> get props => [];
}

// Initial state
class ProfileInitial extends ProfileState {}

// Loading state
class ProfileLoading extends ProfileState {}

// Updating state
class ProfileUpdating extends ProfileState {}

// Error state
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Success state for profile updates
class ProfileUpdateSuccess extends ProfileState {}

// Loaded state containing the user profile
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}


class ProfileFilePicked extends ProfileState {
  File file;
  ProfileFilePicked({required this.file});
}