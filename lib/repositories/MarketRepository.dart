import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/MarketDTO.dart';
import 'package:dio/dio.dart';

class MarketRepository{
  final DioClient api;
  MarketRepository(this.api);

  Future<ResponseCache<List<MarketDTO>>> getAll({bool refresh = false}) async {
    try {
      // Make the API call
      final response = await api.get(Urls.Markets, useCache: false, refresh: refresh);
      print("========================== market =================================");
      print(response.data);

      // Check if 'data' exists and is a list
      if (response.data != null && response.data["data"] is List) {
        final items = (response.data["data"] as List)
            .map((e) => MarketDTO.fromJson(e))
            .toList();
        print("Mapped items: $items"); // Log the mapped items to ensure proper mapping
        return ResponseCache<List<MarketDTO>>(
          isFromCache: refresh,
          result: items,
        );
      }
      // Check if 'data' is a map (i.e., a single market object)
      else if (response.data != null && response.data["data"] is Map) {
        final market = MarketDTO.fromJson(response.data["data"]);
        print("Mapped market: $market");  // Log the single market mapping
        return ResponseCache<List<MarketDTO>>(
          isFromCache: refresh,
          result: [market],
        );
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
  Future<MarketDTO> add(Map<String, dynamic> data)async{
    try{
      print("====== market submit repository ====================================");
      print(jsonEncode(data));
      final response = await api.post(Urls.Markets,data: data, clearCacheAfterPost: true, useToken: true);
      if(!response.data["succeeded"]){
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }
      final item = MarketDTO.fromJson(response.data["data"]);
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