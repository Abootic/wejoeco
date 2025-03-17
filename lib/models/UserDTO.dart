

class UserDTO {
  final int? id;
  final String? username;
  final String? email;
  final String? userType;
  final String? password;

  UserDTO({
    this.id,
    this.username,
    this.email,
    this.userType,
    this.password,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      userType: json['user_type'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type': userType,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'UserDTO(id: $id, username: $username, email: $email, userType: $userType)';
  }
}
