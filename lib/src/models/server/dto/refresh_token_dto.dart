class RefreshTokenDto {
  final String refreshToken;

  const RefreshTokenDto(this.refreshToken);

  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };
}
