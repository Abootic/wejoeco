import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/LoginDto.dart';
import 'package:dio/dio.dart';

import '../models/SupplierDTO.dart';
import '../models/UserDTO.dart';
class SupplierRepository {
  final DioClient api;
  SupplierRepository(this.api);

  // Add method for login, passing user credentials data
  Future<SupplierDTO> add(Map<String, dynamic> data) async {
    try {



      Map<String, dynamic> data1 = {
        'code': data["code"],  // This is correct
        'market_id': data["market_id"],  // Access market_id correctly
        'user_dto': {
          'username': data["user_dto"]["username"],  // Access user_dto and then username
          'email': data["user_dto"]["email"],  // Access user_dto and then email
          'user_type': data["user_dto"]["user_type"],  // Access user_type from user_dto
          'password': data["user_dto"]["password"],  // Access password from user_dto
        }
      };
      final response = await api.post(
          Urls.Suppliers,
          data: data1,
          clearCacheAfterPost: true,
          useToken: false
      );

      print("Response of supplier creation: $response");

      // Check if the response succeeded
      bool succeeded = response.data["succeeded"] ?? false; // Default to false if null
      if (!succeeded) {
        // Extract error message from response data
        String errorMessage = response.data["message"] ?? 'Unknown error';
        // Throw the error with the message from the response
        throw Exception(errorMessage);
      }

      // Parse the successful response to SupplierDTO model
      final item = SupplierDTO.fromJson(response.data["data"]);
      return item;

    } on DioError catch (e) {
      // Check if it's a DioError with a response (meaning the server sent a response)
      if (e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error from server";
        throw Exception(errorMessage); // Throw a specific exception with the error message from the server
      } else {
        // Handle DioError without a response (e.g., network errors)
        final errorMessage = e.message ?? "Network error occurred";
        throw Exception(errorMessage); // Throw the error message
      }
    } on Exception catch (ex) {
      // Re-throw any other exceptions not related to DioError
      rethrow;
    }
  }
  Future<List<SupplierDTO>> getAll({bool refresh = false}) async {
    print("=======================:  getAll in  SupplierRepository ==========");
    try {
      final response = await api.get(
        Urls.Suppliers,
        useCache: false, // Disable caching
      );
      print("========================= supplier data in SupplierRepository ========================");
      print("Response data: ${response.data}");
      print("Response data type: ${response.data.runtimeType}");

      // Check if the response is a map
      if (response.data is! Map<String, dynamic>) {
        throw Exception("Invalid response format: Expected a map");
      }

      // Extract the 'data' field from the response
      final dynamic responseData = response.data['data'];
      if (responseData == null) {
        throw Exception("No data found in the response");
      }

      // Check if the 'data' field is a list
      if (responseData is! List<dynamic>) {
        throw Exception("Invalid data format: Expected a list");
      }

      // Convert the list into a list of SupplierDTO
      final List<SupplierDTO> suppliers = responseData.map((item) {
        return SupplierDTO.fromJson(item);
      }).toList();

      print("Converted suppliers: ${suppliers}");
      return suppliers;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } on Exception catch (ex) {
      rethrow;
    }
  } Future<SupplierDTO> getById(int id, {bool refresh = false}) async {
    try {
      print("==============================================================================");
      print("supplier getById repository is ${id}");

      // Make the API call
      final response = await api.get("${Urls.Get_Supplier_by_UserId}$id", useCache: false, refresh: refresh);
      print("getById response: ${response}");
      print("getById response.data[succeeded]: ${response.data["succeeded"]}");

      // Check if the response data indicates success
      if (response.data == null || !response.data["succeeded"]) {
        // Handle failure response from API
        String errorMessage = response.data != null
            ? response.data["status"]["message"] ?? "Unknown error"
            : "Response data is null";
        throw NotSuccessException.fromMessage(errorMessage);
      }

      // Safely extract the data and convert it into SupplierDTO
      final item = SupplierDTO.fromJson(response.data);
      return item;

    } on DioError catch (e) {
      // Handle DioError specifically, logging detailed info
      print("DioError: ${e.message}");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;  // Throw the error message to the caller

    } on Exception catch (ex) {
      // Handle any other exception types
      print("Exception occurred: ${ex.toString()}");
      rethrow;  // Rethrow the exception to be handled at a higher level
    }
  }



}
