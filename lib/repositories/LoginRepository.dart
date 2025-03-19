import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/urls.dart';
import '../models/LoginDto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'SharedRepository.dart';

class LoginRepository {
  final DioClient api;
  LoginRepository(this.api);
  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  Future<AuthResponse> login(Map<String, dynamic> data) async {
    try {
      print("ssssssssssssssssssssssssssssssssssssssssssssss");
      print(jsonEncode(data));
      print("url is ${Urls.Login}");

      final response = await api.post(
        Urls.Login,
        data: data,
        clearCacheAfterPost: true,
        useToken: false,
      );

      print("response of login is $response");

      if (response.data is String) {
        print("Received response as String: ${response.data}");
        throw Exception("Received success message instead of JSON object: ${response.data}");
      }

      if (response.data is Map<String, dynamic>) {
        bool succeeded = response.data["succeeded"] ?? false;
        if (!succeeded) {
          throw NotSuccessException.fromMessage(response.data["message"] ?? 'Unknown error');
        }

        String accessToken = response.data["data"]?["accessToken"] ?? "";
        String refreshToken = response.data["data"]?["refreshToken"] ?? "";
        String username = response.data["data"]?["user"]?["username"] ?? "";
        String userType = response.data["data"]?["user"]?["userType"] ?? "";
        int userid = response.data["data"]?["user"]?["id"] ?? 0;

        await _sharedRepository.setData("userId", userid.toString());
        await _sharedRepository.setData("userType", userType);
        await _sharedRepository.setData("accessToken", accessToken);
        await _sharedRepository.setData("username", username); // Store username
        // Optionally store refreshToken if needed
        await _sharedRepository.setData("refreshToken", refreshToken);

        String useridd = await _sharedRepository.getData("userId");
        int u = int.parse(useridd);
        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuu ${u}");

        if (accessToken.isEmpty || refreshToken.isEmpty || username.isEmpty || userType.isEmpty) {
          throw Exception("Missing essential data in response");
        }

        final item = AuthResponse.fromJson({
          "access_token": accessToken,
          "refresh_token": refreshToken,
          "user": {
            "username": username,
            "userType": userType,
            "id": userid,
          },
        });

        return item;
      }

      throw Exception("Invalid response format received");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print("DioException occurred: $errorMessage");
      throw Exception("Failed to log in: $errorMessage");
    } catch (ex) {
      print("General exception in LoginRepository: $ex");
      rethrow;
    }
  }
}