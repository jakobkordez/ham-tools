import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../models/server/dto/create_profile_dto.dart';
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

    try {
      await _client!.logout(
        await _getAccessToken(),
        RefreshTokenDto(_refreshToken!.value),
      );
      localRepo.setServerSettings(null);

      _refreshToken = null;
      _accessToken = null;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Logout failed');
    }
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
  Future<int> getLogEntriesCount({bool? all}) async {
    if (!isAuthenticated) return localRepo.getLogEntriesCount(all: all);

    try {
      final r =
          await _client!.getLogEntriesCount(await _getAccessToken(), all: all);
      return int.parse(r);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get log entries');
    }
  }

  @override
  Future<List<LogEntry>> getLogEntries({
    bool? all,
    String? cursorId,
    DateTime? cursorDate,
    int? limit,
  }) async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    try {
      return _client!.getLogEntries(
        await _getAccessToken(),
        all: all,
        cursorId: cursorId,
        cursorDate: cursorDate?.toIso8601String(),
        limit: limit,
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get log entries');
    }
  }

  @override
  Future<Profile> addProfile(CreateProfileDto profile) async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    try {
      return await _client!.createProfile(await _getAccessToken(), profile);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to create profile');
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    try {
      await _client!.deleteProfile(await _getAccessToken(), id);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete profile');
    }
  }

  @override
  Future<List<Profile>> getProfiles() async {
    if (!isAuthenticated) throw Exception('Not authenticated');

    try {
      return await _client!.getProfiles(await _getAccessToken());
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get profiles');
    }
  }
}
