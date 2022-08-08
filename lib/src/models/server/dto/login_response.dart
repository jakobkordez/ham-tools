import '../user.dart';

class LoginResponse {
  final User user;
  final String refreshToken;
  final String accessToken;

  LoginResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json['user']),
        refreshToken = json['refresh_token'],
        accessToken = json['access_token'];
}
