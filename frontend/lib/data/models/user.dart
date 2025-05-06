class CustomUser {
  final String name;
  final String email;
  final String? gender;
  final int? level;
  final String? profilePicture;
  final bool isActive;
  final bool isStaff;
  final List<String>? groups;
  final List<String>? userPermissions;

  CustomUser({
    required this.name,
    required this.email,
    this.gender,
    this.level,
    this.profilePicture,
    required this.isActive,
    required this.isStaff,
    this.groups,
    this.userPermissions,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      level: json['level'],
      profilePicture: json['profile_picture'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      groups: List<String>.from(json['groups'] ?? []),
      userPermissions: List<String>.from(json['user_permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'level': level,
      'profile_picture': profilePicture,
      'is_active': isActive,
      'is_staff': isStaff,
      'groups': groups,
      'user_permissions': userPermissions,
    };
  }
}
