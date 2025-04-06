import 'dart:convert';
import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/urls.dart';
import '../models/LoginDto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/UserDTO.dart';
import 'SharedRepository.dart';

class LoginRepository {
  final DioClient api;
  LoginRepository(this.api);
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  Future<AuthResponse> login(Map<String, dynamic> data) async {
    try {
      final response = await api.post(
        Urls.Login,
        data: data,
        clearCacheAfterPost: true,
        useToken: false,
      );

      if (response.data is Map<String, dynamic>) {
        bool succeeded = response.data["succeeded"] ?? false;

        if (!succeeded) {
          throw NotSuccessException.fromMessage(response.data["message"] ?? 'Unknown error');
        }

        var data = response.data["data"] ?? {};
        String accessToken = data["accessToken"] ?? "";
        String refreshToken = data["refreshToken"] ?? "";
        String username = data["user"]?["username"] ?? "";
        String userType = data["user"]?["userType"] ?? "";
        int userId = data["user"]?["id"] ?? 0;

        if (accessToken.isEmpty || refreshToken.isEmpty || username.isEmpty || userType.isEmpty) {
          throw Exception("Missing essential data in response");
        }

          await _sharedRepository.setData("userId", userId.toString());
        await _sharedRepository.setData("userType", userType);
        await _sharedRepository.setData("accessToken", accessToken);
        await _sharedRepository.setData("username", username);
        await _sharedRepository.setData("refreshToken", refreshToken);

        print("Login successful, data saved to SharedPreferences"); // Debug log

        return AuthResponse(
          success: true,
          accessToken: accessToken,
          refreshToken: refreshToken,
          user: UserDTO(
            id: userId,
            username: username,
            userType: userType,
          ),
        );
      }

      throw Exception("Invalid response format received");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw Exception("Failed to log in: $errorMessage");
    } catch (ex) {
      rethrow;
    }
  }
}