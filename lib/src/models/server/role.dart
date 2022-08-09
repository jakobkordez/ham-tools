enum Role {
  admin,
  user,
}

extension RoleUtil on Role {
  static Role? tryParse(String value) {
    value = value.toLowerCase();
    for (final role in Role.values) {
      if (role.name == value) return role;
    }
    return null;
  }

  String get name {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.user:
        return 'user';
    }
  }

  String get label {
    switch (this) {
      case Role.admin:
        return 'Administrator';
      case Role.user:
        return 'User';
    }
  }
}
