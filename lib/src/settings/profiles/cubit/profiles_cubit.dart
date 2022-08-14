import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/profile.dart';
import '../../../models/server/dto/create_profile_dto.dart';
import '../../../repository/repository.dart';

part 'profiles_state.dart';

class ProfilesCubit extends Cubit<ProfilesState> {
  final Repository repo;

  ProfilesCubit(this.repo) : super(ProfilesInitial()) {
    load();
  }

  void load() async {
    try {
      final profiles = await repo.getProfiles();
      emit(ProfilesLoaded(profiles));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }

  void addProfile(CreateProfileDto profile) async {
    try {
      await repo.addProfile(profile);
      final profiles = await repo.getProfiles();
      emit(ProfilesLoaded(profiles));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }

  void deleteProfile(String id) async {
    try {
      await repo.deleteProfile(id);
      final profiles = await repo.getProfiles();
      emit(ProfilesLoaded(profiles));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }
}
