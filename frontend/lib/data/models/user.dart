class User {
  final String name;
  final String email;
  final String? gender;
  final int? level;
  final String? profilePicture;

  User({
    required this.name,
    required this.email,
    this.gender,
    this.level,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      level: json['level'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'level': level,
      'profile_picture': profilePicture,
    };
  }
}
