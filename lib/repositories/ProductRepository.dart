import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/MarketDTO.dart';
import '../models/ProductDTO.dart';
import 'package:dio/dio.dart';
class ProductRepository{
  final DioClient api;

  ProductRepository(this.api);

  Future<ResponseCache<List<ProductDTO>>> getAll({bool refresh = false}) async {
    try {
      // Make the API call
      final response = await api.get(Urls.Products, useCache: false, refresh: refresh);
      print("========================== product =================================");
      print(response.data);

      // Check if 'data' exists and is a List
      if (response.data != null && response.data is List) {
        final items = (response.data as List)
            .map((e) => ProductDTO.fromJson(e))
            .toList();

        print("Mapped items: $items"); // Log the mapped items to ensure proper mapping
        return ResponseCache<List<ProductDTO>>(
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
              .map((e) => ProductDTO.fromJson(e))
              .toList();

          print("Mapped products: $res");  // Log the mapped products
          return ResponseCache<List<ProductDTO>>(
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
Future<ProductDTO> add(Map<String, dynamic> data)async{
    try{

      final response = await api.post(Urls.Products,data: data, clearCacheAfterPost: true, useToken: true);
      if(!response.data["succeeded"]){
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }
      final item = ProductDTO.fromJson(response.data);
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
}