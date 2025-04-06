import 'dart:convert';

import '../apis/dio_client.dart';
import '../apis/dio_exception.dart';
import '../apis/response_cache_model.dart';
import '../apis/urls.dart';
import '../models/MarketDTO.dart';
import 'package:dio/dio.dart';

import '../models/SupplierProfitDTO.dart';
import '../models/SupplierProfitPercentageDTO.dart';
class SupplierProfitRepository {
  final DioClient api;

  SupplierProfitRepository(this.api);

  Future<ResponseCache<List<SupplierProfitDTO>>> getAll({bool refresh = false}) async {
    try {
      final response = await api.get(Urls.Supplierprofit, useCache: false, refresh: refresh);
      print("========================== SupplierProfitDTO =================================");
      print(response.data);
      print("========================== SupplierProfitDTO =================================");

      if (response.data != null && response.data is List) {
        final items = (response.data as List)
            .map((e) => SupplierProfitDTO.fromJson(e))
            .toList();
        print("Mapped items: ${items.first.profit}"); // Log the mapped items to ensure proper mapping
        return ResponseCache<List<SupplierProfitDTO>>(
          isFromCache: refresh,
          result: items,
        );
      } else if (response.data != null && response.data is Map) {
        final supplierprofi = SupplierProfitDTO.fromJson(response.data);
        return ResponseCache<List<SupplierProfitDTO>>(
          isFromCache: refresh,
          result: [supplierprofi],
        );
      } else {
        // Ensure a valid empty list is returned if data is neither a list nor a map
        return ResponseCache<List<SupplierProfitDTO>>(
          isFromCache: refresh,
          result: [],
        );
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print("DioException occurred: $errorMessage");
      rethrow;
    } catch (ex) {
      print("General exception in getAll: $ex");
      rethrow;
    }
  }

  Future<SupplierProfitDTO> add(Map<String, dynamic> data) async {
    try {
      print("====== market submit repository ====================================");
      print(jsonEncode(data));
      final response = await api.post(Urls.marketsUrl, data: data, clearCacheAfterPost: true, useToken: true);
      if (!response.data["succeeded"]) {
        throw NotSuccessException.fromMessage(response.data["status"]["message"]);
      }
      final item = SupplierProfitDTO.fromJson(response.data["data"]);
      return item;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    } on Exception catch (ex) {
      rethrow;
    }
  }

  Future<SupplierProfitPercentageDTO> getProfitBySupplierId(int id, {bool refresh = false}) async {
    try {
      final response = await api.post(Urls.get_supplier_profit,
          data: {"user_id": id},
          clearCacheAfterPost: true,
          useToken: true);

      if (response.data == null || !response.data["succeeded"]) {
        throw NotSuccessException.fromMessage("Error retrieving data.");
      }

      var profitData = response.data["data"];

      if (profitData is Map<String, dynamic>) {
        return SupplierProfitPercentageDTO.fromJson(profitData);
      }

      throw Exception("Unexpected data structure in API response");
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
  Future<List<SupplierProfitDTO>> CalculateMarketProfit(int id, {bool refresh = false}) async {
    try {
      print("==============================================================================");
      print(" SupplierProfitDTO here we go ");
      print("==============================================================================");
      print(" SupplierProfitDTO for user ID: ${id}");

      // Make the API call
      Map<String, dynamic> data = {
        "market_id": id,
        "month": DateTime.now().toIso8601String().substring(0, 7) + "-01"  // "2025-03-01"
      };

      final response = await api.post(Urls.Supplierprofit, data: data, clearCacheAfterPost: true, useToken: true);
      print("API response: $response");

      // Check if the response is a string or a map and handle it accordingly
      if (response.data is String) {
        print("Received response is a string: ${response.data}");
        throw NotSuccessException.fromMessage("Expected a map, but received a string.");
      }

      // If the response is a map, proceed to process it
      print("API response status: ${response.data['succeeded']}");

      // Check if the response indicates success
      if (response.data == null || !response.data["succeeded"]) {
        String errorMessage = response.data["status"] != null
            ? response.data["status"]["message"] ?? "Unknown error"
            : "Response data is null";
        throw NotSuccessException.fromMessage(errorMessage);
      }

      // Safely extract the list of orders from response data and map it to OrderDTO
      List<SupplierProfitDTO> orders = (response.data["data"] as List)
          .map((order) => SupplierProfitDTO.fromJson(order))
          .toList();

      return orders;

    } on DioError catch (e) {
      print("DioError: ${e.message}");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;

    } on Exception catch (ex) {
      print("Exception occurred: ${ex.toString()}");
      rethrow;
    }
  }


}
