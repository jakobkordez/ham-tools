import 'dart:convert';

class JwtToken {
  final String value;

  late final String userId;
  late final int iat;
  late final int? exp;

  JwtToken(this.value) {
    final parts = value.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT token');

    final payload = json.decode(utf8.decode(base64.decode(parts[1])));
    userId = payload['user_id'];
    iat = payload['iat'];
    exp = payload['exp'];
  }

  bool get isExpired =>
      exp != null && exp! < (DateTime.now().millisecondsSinceEpoch ~/ 1000);
}
