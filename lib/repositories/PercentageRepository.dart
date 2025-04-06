import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';

import 'package:dio/dio.dart';

import '../models/PercentageDTO.dart';

class PercentageRepository{
  final DioClient api;
  PercentageRepository(this.api);

  Future<ResponseCache<List<PercentageDTO>>> getAll({bool refresh = false}) async {
    try {
      // Make the API call
      final response = await api.get(Urls.Percentage, useCache: false, refresh: refresh);
      print("========================== market =================================");
      print(response.data);

      // Check if 'data' exists and is a list
      if (response.data != null && response.data["data"] is List) {
        final items = (response.data["data"] as List)
            .map((e) => PercentageDTO.fromJson(e))
            .toList();
        print("Mapped items: $items"); // Log the mapped items to ensure proper mapping
        return ResponseCache<List<PercentageDTO>>(
          isFromCache: refresh,
          result: items,
        );
      }
      // Check if 'data' is a map (i.e., a single market object)
      else if (response.data != null && response.data["data"] is Map) {
        final res = PercentageDTO.fromJson(response.data["data"]);
        print("Mapped market: $res");  // Log the single market mapping
        return ResponseCache<List<PercentageDTO>>(
          isFromCache: refresh,
          result: [res],
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
  Future<PercentageDTO> add(int market_id)async{
    try{
      print("====== percentage submit repository ====================================");
      print(market_id);
      final response = await api.get("${Urls.assign_percentage_value_to_suppliers}?market_id=$market_id", useCache: false);
      if(!response.data["succeeded"]){
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }
      final item = PercentageDTO.fromJson(response.data["data"]);
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