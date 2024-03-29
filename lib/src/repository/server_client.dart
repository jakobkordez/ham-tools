import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/log_entry.dart';
import '../models/profile.dart';
import '../models/server/dto/create_log_entry_dto.dart';
import '../models/server/dto/create_profile_dto.dart';
import '../models/server/dto/create_user_dto.dart';
import '../models/server/dto/delete_log_entries_dto.dart';
import '../models/server/dto/login_dto.dart';
import '../models/server/dto/login_response.dart';
import '../models/server/dto/refresh_response.dart';
import '../models/server/dto/refresh_token_dto.dart';
import '../models/server/dto/update_log_entry.dart';
import '../models/server/dto/update_profile_dto.dart';
import '../models/server/dto/update_user_dto.dart';
import '../models/server/user.dart';

part 'server_client.g.dart';

@RestApi(baseUrl: 'http://localhost:3000/')
abstract class ServerClient {
  factory ServerClient(Dio dio, {String? baseUrl}) = _ServerClient;

  // Auth
  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginDto user);

  @POST('/auth/refresh')
  Future<RefreshResponse> refresh(@Body() RefreshTokenDto token);

  @POST('/auth/logout')
  Future<void> logout(
    @Header('Authorization') String token,
    @Body() RefreshTokenDto refreshToken,
  );

  // Users
  @POST('/users')
  Future<User> createUser(
    @Header('Authorization') String token,
    @Body() CreateUserDto createUserDto,
  );

  @GET('/users')
  Future<List<User>> getUsers(@Header('Authorization') String token);

  @GET('/users/me')
  Future<User> getSelf(@Header('Authorization') String token);

  @PATCH('/users/me')
  Future<User> updateSelf(
    @Header('Authorization') String token,
    @Body() UpdateUserDto updateUserDto,
  );

  @GET('/users/{id}')
  Future<User> getUser(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @PATCH('/users/{id}')
  Future<User> updateUser(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateUserDto updateUserDto,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUser(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  // Log entries
  @POST('/log')
  Future<LogEntry> createLogEntry(
    @Header('Authorization') String token,
    @Body() CreateLogEntryDto logEntry,
  );

  @POST('/log/many')
  Future<List<LogEntry>> createLogEntries(
    @Header('Authorization') String token,
    @Body() List<CreateLogEntryDto> logEntries,
  );

  @GET('/log/count')
  Future<String> getLogEntriesCount(
    @Header('Authorization') String token, {
    @Query('all') bool? all,
  });

  @GET('/log')
  Future<List<LogEntry>> getLogEntries(
    @Header('Authorization') String token, {
    @Query('all') bool? all,
    @Query('cursorId') String? cursorId,
    @Query('cursorDate') String? cursorDate,
    @Query('limit') int? limit,
  });

  @GET('/log/{id}')
  Future<LogEntry> getLogEntry(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @PATCH('/log/{id}')
  Future<LogEntry> updateLogEntry(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateLogEntryDto logEntry,
  );

  @DELETE('/log/{id}')
  Future<void> deleteLogEntry(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @DELETE('/log')
  Future<void> deleteLogEntries(
    @Header('Authorization') String token,
    @Body() DeleteLogEntriesDto logEntries,
  );

  // Profiles
  @POST('/profiles')
  Future<Profile> createProfile(
    @Header('Authorization') String token,
    @Body() CreateProfileDto profile,
  );

  @GET('/profiles')
  Future<List<Profile>> getProfiles(@Header('Authorization') String token);

  @GET('/profiles/{id}')
  Future<Profile> getProfile(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @PATCH('/profiles/{id}')
  Future<Profile> updateProfile(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateProfileDto profile,
  );

  @DELETE('/profiles/{id}')
  Future<void> deleteProfile(
    @Header('Authorization') String token,
    @Path('id') String id,
  );
}
