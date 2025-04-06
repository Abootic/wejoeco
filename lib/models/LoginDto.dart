import 'UserDTO.dart';

class AuthResponse {
  final bool success;
  final String accessToken;
  final String refreshToken;
  final   UserDTO? user;

  AuthResponse({
    required this.success,
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['succeeded'] ?? false,
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'succeeded': success,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
    };
  }
}