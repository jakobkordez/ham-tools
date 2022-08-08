class UpdateUserDto {
  final String? username;
  final String? password;
  final String? name;
  final List<String>? callsigns;

  const UpdateUserDto({
    this.username,
    this.password,
    this.name,
    this.callsigns,
  });

  Map<String, dynamic> toJson() => {
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        if (name != null) 'name': name,
        if (callsigns != null) 'callsigns': callsigns,
      };
}
