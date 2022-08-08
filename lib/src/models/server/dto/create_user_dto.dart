class CreateUserDto {
  final String username;
  final String password;
  final String name;
  final List<String> callsigns;

  const CreateUserDto({
    required this.username,
    required this.password,
    required this.name,
    required this.callsigns,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'callsigns': callsigns,
      };
}
