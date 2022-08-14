part of 'server_settings_cubit.dart';

enum ServerSettingsStatus {
  initializing,
  ready,
  authenticating,
  error,
}

class ServerSettingsState extends Equatable {
  final ServerSettingsStatus status;
  final String? error;
  final bool isAuthenticated;
  final String serverUrl;
  final String username;
  final String password;
  final User? user;

  const ServerSettingsState({
    required this.status,
    this.error,
    this.isAuthenticated = false,
    this.serverUrl = '',
    this.username = '',
    this.password = '',
    this.user,
  });

  ServerSettingsState copyWith({
    ServerSettingsStatus? status,
    String? error,
    bool? isAuthenticated,
    String? serverUrl,
    String? username,
    String? password,
    User? user,
  }) {
    final newAuth = isAuthenticated ?? this.isAuthenticated;
    final newStatus = status ?? this.status;

    return ServerSettingsState(
      status: newStatus,
      error: newStatus == ServerSettingsStatus.error
          ? (error ?? this.error)
          : null,
      isAuthenticated: newAuth,
      serverUrl: serverUrl ?? this.serverUrl,
      username: username ?? this.username,
      password: password ?? this.password,
      user: newAuth ? (user ?? this.user) : null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        isAuthenticated,
        serverUrl,
        username,
        password,
        user,
      ];
}
