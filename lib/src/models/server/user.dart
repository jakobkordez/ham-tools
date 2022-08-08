import 'role.dart';

class User {
  final String id;
  final String username;
  final String name;
  final List<String> callsigns;
  final List<Role> roles;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.callsigns,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        username: json['username'],
        name: json['name'],
        callsigns: (json['callsigns'] as List).cast(),
        roles:
            (json['roles'] as List).map((e) => RoleUtil.tryParse(e)!).toList(),
      );
}
