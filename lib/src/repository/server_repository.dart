import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/server/jwt_token.dart';
import '../models/log_entry.dart';
import '../models/server/dto/create_log_entry_dto.dart';
import '../models/server/dto/login_dto.dart';
import '../models/server/dto/refresh_token_dto.dart';
import '../models/server/server_settings.dart';
import '../models/server/user.dart';
import 'local_repository.dart';
import 'repository.dart';
import 'server_client.dart';

class ServerRepository extends Repository {
  final Dio dio;
  final LocalRepository localRepo;

  String? _baseUrl;
  String? get baseUrl => _baseUrl;
  ServerClient? _client;

  User? _user;
  User? get user => _user;

  JwtToken? _refreshToken;
  JwtToken? _accessToken;

  ServerRepository._({
    Dio? dio,
    required this.localRepo,
  }) : dio = dio ?? Dio();

  bool get isAuthenticated => _refreshToken != null;

  static Future<ServerRepository> init({
    Dio? dio,
    required LocalRepository localRepository,
  }) async {
    final repo = ServerRepository._(
      dio: dio,
      localRepo: localRepository,
    );
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    final serverSettings = await localRepo.getServerSettings();
    if (serverSettings?.refreshToken == null) return;

    _baseUrl = serverSettings!.serverUrl;
    _client = ServerClient(dio, baseUrl: _baseUrl);
    _refreshToken = JwtToken(serverSettings.refreshToken!);
    try {
      _user = await _client!.getSelf(await _getAccessToken());
    } catch (e) {
      debugPrint(e.toString());
      _refreshToken = null;
      _accessToken = null;
      _user = null;
    }
  }

  Future<bool> authenticate(
    String server,
    String username,
    String password,
  ) async {
    _refreshToken = null;
    _accessToken = null;
    _user = null;

    _client = ServerClient(dio, baseUrl: server);
    final res =
        await _client!.login(LoginDto(username: username, password: password));

    _refreshToken = JwtToken(res.refreshToken);
    _accessToken = JwtToken(res.accessToken);
    _user = res.user;

    localRepo.setServerSettings(ServerSettings(
      serverUrl: server,
      refreshToken: res.refreshToken,
    ));

    return true;
  }

  Future<void> logout() async {
    if (!isAuthenticated) return;

    await _client!.logout(
      await _getAccessToken(),
      RefreshTokenDto(_refreshToken!.value),
    );
    localRepo.setServerSettings(null);

    _refreshToken = null;
    _accessToken = null;
  }

  Future<String> _getAccessToken([bool refresh = false]) async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    if (refresh || (_accessToken?.isExpired ?? true)) {
      try {
        final res =
            await _client!.refresh(RefreshTokenDto(_refreshToken!.value));
        _accessToken = JwtToken(res.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token');
      }
    }

    return 'Bearer ${_accessToken!.value}';
  }

  @override
  Future<LogEntry> addLogEntry(LogEntry entry) async {
    if (!isAuthenticated) {
      localRepo.addLogEntry(entry.copyWith(
        createdAt: DateTime.now().toUtc(),
      ));
      throw Exception('Not authenticated');
    }

    try {
      return await _client!.createLogEntry(
        await _getAccessToken(),
        CreateLogEntryDto(data: entry.toAdiMap()),
      );
    } catch (e) {
      debugPrint(e.toString());
      localRepo.addLogEntry(entry.copyWith(
        createdAt: DateTime.now().toUtc(),
      ));
      throw Exception('Failed to add log entry');
    }
  }

  @override
  Future<LogEntry?> getLastLogEntry() => localRepo.getLastLogEntry();

  @override
  Future<List<LogEntry>> getLogEntries({
    DateTime? after,
    DateTime? before,
    bool all = false,
  }) async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    try {
      return _client!.getLogEntries(
        await _getAccessToken(),
        all: all,
        after: after?.toIso8601String(),
        before: before?.toIso8601String(),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get log entries');
    }
  }
}
