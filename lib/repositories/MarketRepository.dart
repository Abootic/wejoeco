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
      // Make the API call to fetch data, optionally using cache
      final response = await api.get(Urls.Markets, useCache: true, refresh: refresh);

      // Checking the success status in the response data
      if (!response.data["succeeded"]) {
        // Throw a custom exception when the request is not successful
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }

      // Mapping the response data to a list of MarketDTO objects
      final items = (response.data["data"] as List)
          .map((e) => MarketDTO.fromJson(e))
          .toList();

      // Return the data wrapped in a ResponseCache object
      return ResponseCache<List<MarketDTO>>(
        isFromCache: refresh,
        result: items,
      );

    } on DioException catch (e) {
      // Handle DioException (new error handling)
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print("DioException occurred: $errorMessage");
      throw Exception(errorMessage); // Re-throw the exception with a descriptive message

    } catch (ex) {
      // Handle any other errors
      print("General exception in getAll: $ex");
      rethrow; // Propagate the error further
    }
  }
  Future<MarketDTO> add(Map<String, dynamic> data)async{
    try{
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