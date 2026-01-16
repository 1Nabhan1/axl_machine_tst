class UserModel {
  final String username;
  final String fullName;
  final String password; // plain for test only
  final String dob;
  final String profileImagePath;

  UserModel({
    required this.username,
    required this.fullName,
    required this.password,
    required this.dob,
    required this.profileImagePath,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      fullName: map['fullName'],
      password: map['password'],
      dob: map['dob'],
      profileImagePath: map['profileImagePath'],
    );
  }

  Map<String, dynamic> toMap() => {
    'username': username,
    'fullName': fullName,
    'password': password,
    'dob': dob,
    'profileImagePath': profileImagePath,
  };
  UserModel copyWith({
    String? username,
    String? fullName,
    String? password,
    String? dob,
    String? profileImagePath,
  }) {
    return UserModel(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
