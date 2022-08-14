import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/server/user.dart';
import '../../../repository/server_repository.dart';

part 'server_settings_state.dart';

class ServerSettingsCubit extends Cubit<ServerSettingsState> {
  final ServerRepository serverRepo;

  ServerSettingsCubit({required this.serverRepo})
      : super(ServerSettingsState(
          status: ServerSettingsStatus.ready,
          isAuthenticated: serverRepo.isAuthenticated,
          user: serverRepo.user,
          username: serverRepo.user?.username ?? '',
          serverUrl: serverRepo.baseUrl ?? '',
        ));

  void setServer(String value) => emit(state.copyWith(serverUrl: value));

  void setUsername(String value) => emit(state.copyWith(username: value));

  void setPassword(String value) => emit(state.copyWith(password: value));

  void submit() async {
    emit(state.copyWith(status: ServerSettingsStatus.authenticating));

    if (state.serverUrl.isEmpty) {
      emit(state.copyWith(
        status: ServerSettingsStatus.error,
        error: 'Server URL is required',
      ));
      return;
    } else if (state.username.isEmpty) {
      emit(state.copyWith(
        status: ServerSettingsStatus.error,
        error: 'Username is required',
      ));
      return;
    } else if (state.password.isEmpty) {
      emit(state.copyWith(
        status: ServerSettingsStatus.error,
        error: 'Password is required',
      ));
      return;
    }

    try {
      await serverRepo.authenticate(
          state.serverUrl, state.username, state.password);
      emit(state.copyWith(
        status: ServerSettingsStatus.ready,
        isAuthenticated: true,
        user: serverRepo.user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ServerSettingsStatus.error,
        error: e.toString(),
      ));
    }
  }

  void logout() async {
    try {
      await serverRepo.logout();
      emit(state.copyWith(
        status: ServerSettingsStatus.ready,
        isAuthenticated: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ServerSettingsStatus.error,
        error: e.toString(),
      ));
    }
  }
}
