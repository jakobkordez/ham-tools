import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/server/jwt_token.dart';
import '../models/log_entry.dart';
import '../models/server/dto/create_log_entry_dto.dart';
import '../models/server/dto/login_dto.dart';
import '../models/server/dto/refresh_token_dto.dart';
import '../models/server/user.dart';
import 'local_repository.dart';
import 'repository.dart';
import 'server_client.dart';

class ServerRepository extends Repository {
  final ServerClient client;
  final LocalRepository localRepository;

  JwtToken? _refreshToken;
  JwtToken? _accessToken;

  ServerRepository({
    Dio? dio,
    String? baseUrl,
    required this.localRepository,
  }) : client = ServerClient(dio ?? Dio(), baseUrl: baseUrl);

  bool get isAuthenticated => _refreshToken != null;

  Future<User> authenticate(String username, String password) async {
    final res =
        await client.login(LoginDto(username: username, password: password));
    _refreshToken = JwtToken(res.refreshToken);
    _accessToken = JwtToken(res.accessToken);
    return res.user;
  }

  Future<void> logout() async {
    if (_refreshToken == null) return;

    await client.logout(
      await _getAccessToken(),
      RefreshTokenDto(_refreshToken!.value),
    );
    _refreshToken = null;
    _accessToken = null;
  }

  Future<String> _getAccessToken([bool refresh = false]) async {
    if (_refreshToken == null) throw Exception('No refresh token');

    if (refresh || (_accessToken?.isExpired ?? true)) {
      try {
        final res = await client.refresh(RefreshTokenDto(_refreshToken!.value));
        _accessToken = JwtToken(res.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token');
      }
    }

    return 'Bearer ${_accessToken!.value}';
  }

  @override
  Future<LogEntry> addLogEntry(LogEntry entry) async {
    try {
      return await client.createLogEntry(
        await _getAccessToken(),
        CreateLogEntryDto(data: entry.toAdiMap()),
      );
    } catch (e) {
      debugPrint(e.toString());
      localRepository.addLogEntry(entry);
      throw Exception('Failed to add log entry');
    }
  }

  @override
  Future<LogEntry?> getLastLogEntry() => localRepository.getLastLogEntry();

  @override
  Future<List<LogEntry>> getLogEntries({
    DateTime? after,
    DateTime? before,
    bool all = false,
  }) async {
    try {
      return client.getLogEntries(
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
