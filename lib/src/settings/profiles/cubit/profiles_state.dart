part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  const ProfilesState();

  @override
  List<Object> get props => [];
}

class ProfilesInitial extends ProfilesState {}

class ProfilesLoaded extends ProfilesState {
  final List<Profile> profiles;

  const ProfilesLoaded(this.profiles);

  @override
  List<Object> get props => [profiles];
}

class ProfilesError extends ProfilesState {
  final String error;

  const ProfilesError(this.error);

  @override
  List<Object> get props => [error];
}
