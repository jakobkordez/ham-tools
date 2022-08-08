class RefreshResponse {
  final String accessToken;

  RefreshResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'];
}
