class ServerSettings {
  final String? serverUrl;
  final String? refreshToken;

  const ServerSettings({
    this.serverUrl,
    this.refreshToken,
  });

  ServerSettings.fromJson(Map<String, dynamic> json)
      : serverUrl = json['server_url'],
        refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
        if (serverUrl != null) 'server_url': serverUrl,
        if (refreshToken != null) 'refresh_token': refreshToken,
      };
}
