import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/MarketDTO.dart';
import '../models/OrderDTO.dart';
import '../models/ProductDTO.dart';
import 'package:dio/dio.dart';
class OrderRepository{
  final DioClient api;

  OrderRepository(this.api);

  Future<ResponseCache<List<OrderDTO>>> getAll({bool refresh = false}) async {
    try {
      // Make the API call
      final response = await api.get(Urls.Orders, useCache: false, refresh: refresh);
      print("========================== OrderDTO =================================");
      print(response.data);

      // Check if 'data' exists and is a List
      if (response.data != null && response.data is List) {
        final items = (response.data as List)
            .map((e) => OrderDTO.fromJson(e))
            .toList();

        print("Mapped items: $items"); // Log the mapped items to ensure proper mapping
        return ResponseCache<List<OrderDTO>>(
          isFromCache: refresh,
          result: items,
        );
      }
      // Check if 'data' exists and is a Map (i.e., a map containing a 'data' field)
      else if (response.data != null && response.data is Map<String, dynamic>) {
        print("========================================");
        print("runtype  ${response.data.runtimeType}");

        // Check if the map contains a "data" field and process it
        if (response.data.containsKey("data")) {
          // If 'data' is a list of products
          final res = (response.data["data"] as List)
              .map((e) => OrderDTO.fromJson(e))
              .toList();

          print("Mapped products: $res");  // Log the mapped products
          return ResponseCache<List<OrderDTO>>(
            isFromCache: refresh,
            result: res, // Return the list of products
          );
        } else {
          // Handle the case where "data" field is missing
          throw Exception("Response does not contain 'data' field.");
        }
      }
      // Handle cases where 'data' is neither a list nor a map
      else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      // Handle DioException
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print("DioException occurred: $errorMessage");
      throw Exception(errorMessage);
    } catch (ex) {
      // Catch all other exceptions
      print("General exception in getAll: $ex");
      rethrow;
    }
  }
  Future<OrderDTO> add(Map<String, dynamic> data)async{
    try{

      final response = await api.post(Urls.Orders,data: data, clearCacheAfterPost: true, useToken: true);
      if(!response.data["succeeded"]){
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }
      final item = OrderDTO.fromJson(response.data);
      return item;
    }
    on DioError catch (e) {

      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    on Exception catch(ex){
      rethrow;
    }
  }
  Future<OrderDTO> remove(int id, {bool refresh = false}) async {
    try {
      // Sending the DELETE request
      final response = await api.delete("${Urls.Orders}/$id/");

      // Log the full response to inspect it
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      // Handle 204 No Content response
      if (response.statusCode == 204) {
        print("Order deleted successfully with no content returned.");
        return OrderDTO();  // You can return an empty DTO or just handle it as a success confirmation
      }

      // Handle success response from the server
      if (response.data != null && response.data['succeeded'] != null && response.data['succeeded']) {
        print("Order deletion succeeded");
        return OrderDTO.fromJson(response.data);
      } else {
        // If the operation wasn't successful
        throw Exception(response.data['message'] ?? 'Unknown error');
      }

    } on DioError catch (e) {
      // Handle Dio errors
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print("Dio error: $errorMessage");
      throw errorMessage;
    } on Exception catch (ex) {
      // Handle any other exceptions
      print("Exception: ${ex.toString()}");
      rethrow;
    }
  }

  Future<List<OrderDTO>> getByUserId(int id, {bool refresh = false}) async {
    try {
      print("==============================================================================");
      print("Fetching orders for user ID: ${id}");

      // Make the API call
      final response = await api.get("${Urls.Get_Customer_Order}?user_id=$id", useCache: false, refresh: refresh);
      print("API response: $response");
      print("API response status: ${response.data['succeeded']}");

      // Check if the response indicates success
      if (response.data == null || !response.data["succeeded"]) {
        // Handle failure response from API
        String errorMessage = response.data != null
            ? response.data["status"]["message"] ?? "Unknown error"
            : "Response data is null";
        throw NotSuccessException.fromMessage(errorMessage);
      }

      // Safely extract the list of orders from response data and map it to OrderDTO
      List<OrderDTO> orders = (response.data["data"] as List)
          .map((order) => OrderDTO.fromJson(order))
          .toList();

      return orders;

    } on DioError catch (e) {
      // Handle DioError specifically, logging detailed info
      print("DioError: ${e.message}");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;  // Throw the error message to the caller

    } on Exception catch (ex) {
      // Handle any other exceptions
      print("Exception occurred: ${ex.toString()}");
      rethrow;  // Rethrow the exception to be handled at a higher level
    }
  }


}