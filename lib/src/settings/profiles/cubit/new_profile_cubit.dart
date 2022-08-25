import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/dxcc_entity.dart';
import '../../../models/server/dto/create_profile_dto.dart';
import 'profiles_cubit.dart';

part 'new_profile_state.dart';

class NewProfileCubit extends Cubit<NewProfileState> {
  final ProfilesCubit profilesCubit;

  NewProfileCubit(this.profilesCubit) : super(const NewProfileState());

  void setProfileName(String value) => emit(state.copyWith(profileName: value));

  void setCallsign(String value) => emit(state.copyWith(callsign: value));

  void setDxcc(String value) => emit(state.copyWith(dxcc: value));

  void setCqZone(String value) => emit(state.copyWith(cqZone: value));

  void setItuZone(String value) => emit(state.copyWith(ituZone: value));

  void setName(String value) => emit(state.copyWith(name: value));

  void setGridsquare(String value) => emit(state.copyWith(gridsquare: value));

  void setQth(String value) => emit(state.copyWith(qth: value));

  void setState(String value) => emit(state.copyWith(state: value));

  void setCountry(String value) => emit(state.copyWith(country: value));

  void submit() {
    profilesCubit.addProfile(state.toCreateProfile());
    emit(const NewProfileState());
  }
}
