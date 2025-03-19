import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/CustomerDTO.dart';
import '../models/LoginDto.dart';
import 'package:dio/dio.dart';

class CustomerRepository {
  final DioClient api;
  CustomerRepository(this.api);

  // Add method for login, passing user credentials data
  Future<CustomerDTO> add(Map<String, dynamic> data) async {
    try {
      print("customerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(jsonEncode(data));
      // Perform POST request using the DioClient
      print("url is ${Urls.Customers}");


      final response = await api.post(
          Urls.Customers,
          data: data,
          clearCacheAfterPost: true,
          useToken: false
      );

      print("Response of Customer creation: $response");

      // Check if the response succeeded
      bool succeeded = response.data["succeeded"] ?? false; // Default to false if null
      if (!succeeded) {
        // Extract error message from response data
        String errorMessage = response.data["message"] ?? 'Unknown error';
        // Throw the error with the message from the response
        throw Exception(errorMessage);
      }

      // Parse the successful response to SupplierDTO model
      final item = CustomerDTO.fromJson(response.data["data"]);
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

  Future<List<CustomerDTO>> getAll({bool refresh = false}) async {
    print("==== refresh in getAll colleges: ${refresh} ==========");
    try {
      final response = await api.get(
        Urls.Suppliers,
        useCache: false, // Disable caching
      );

      if (!response.data["succeeded"]) {
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }

      // Map the response data to SupplierDTO list
      final items = (response.data["data"] as List)
          .map((e) => CustomerDTO.fromJson(e))
          .toList();

      return items; // Return the list directly, without ResponseCache
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } on Exception catch (ex) {
      rethrow;
    }
  }


  Future<CustomerDTO> getById(int id, {bool refresh = false}) async {
    try {
      print("supplier getById is ${id}");

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
      final item = CustomerDTO.fromJson(response.data["data"]);
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
