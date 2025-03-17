import 'UserDTO.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserDTO? user; // Make user nullable

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.user, // Make user optional
  });

  // Factory constructor to create an AuthResponse object from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
    );
  }


  // Convert the AuthResponse object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user?.toJson(), // Safely call toJson() if user is not null
    };
  }

  // You can add a helper method to check if user exists:
  bool get hasUser => user != null;
}

