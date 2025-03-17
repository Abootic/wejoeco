import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../repositories/SharedRepository.dart';
import '../utilities/service_locator.dart';
import 'urls.dart';

class DioClient {
  final Dio _dio;
  late final DioCacheInterceptor _cacheInterceptor;
  late final HiveCacheStore _cacheStore;

  DioClient(this._dio) {
    _cacheStore = HiveCacheStore(_getCachePath()); // Use absolute path for cache directory

    final cacheOptions = CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache, // Always use cache
      maxStale: const Duration(days: 10), // Cache expiration time
      hitCacheOnErrorExcept: [401, 403], // Don't cache errors like 401, 403
    );

    _cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

    _dio
      ..options.baseUrl = Urls.BaseUrl
      ..options.connectTimeout = Duration(milliseconds: Urls.connectionTimeout)
      ..options.receiveTimeout = Duration(milliseconds: Urls.receiveTimeout)
      ..options.responseType = ResponseType.json
      ..interceptors.add(_cacheInterceptor);  // Add the cache interceptor
  }

  // Get the cache path dynamically based on the platform
  String _getCachePath() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Directory.systemTemp.path + '/cache'; // Use system temp directory for mobile
    }
    return './cache'; // Default for other platforms
  }

  // Request Storage Permission for Android and iOS
  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  // Clear Cache
  Future<bool> clearCache() async {
    try {
      await _cacheStore.clean(); // Clear all cached data
      return true;
    } catch (e) {
      print("Error clearing cache: ${e.toString()}");
      return false;
    }
  }

  // Get Request with Cache Handling
  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool useCache = true,
        bool refresh = false,
      }) async {
    print("urllllllllllllllllll is ${url}");
    try {
      if (refresh) {
        // Clear cache for this specific URL
        await _cacheStore.delete(Uri.parse(url) as String);
      }

      if (options == null) {
        options = Options(headers: await _getHeaders());
      } else {
        options = options.copyWith(headers: await _getHeaders());
      }

      final cacheOptions = CacheOptions(
        policy: useCache ? CachePolicy.forceCache : CachePolicy.refresh, // Cache if needed
        maxStale: const Duration(seconds: Urls.maxStale),
        store: _cacheStore,
      );
      print("Cache cleared for GET request: $url");

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: useCache ? cacheOptions.toOptions() : options, // Apply caching if enabled
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      print("Cache Hit: ${response.extra['cached'] ?? false}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Dio client GET: $e");
      }
      rethrow;
    }
  }

  // Post Request with Cache Handling
  Future<Response> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool clearCacheAfterPost = false,
        bool useToken = true,
      }) async {
    try {
      if (options == null) {
        options = Options(headers: await _getHeaders(useToken: useToken));
      } else {
        options = options.copyWith(headers: await _getHeaders(useToken: useToken));
      }
      print("POST Request URI: $uri");
      print("POST Request URL: ${Urls.BaseUrl + uri}");
      print("POST Data: ${jsonEncode(data)}");

      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (clearCacheAfterPost) {
        await clearCache(); // Clear cache after POST request if needed
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Dio client POST: $e");
      }
      rethrow;
    }
  }

  // Helper Method to Get Headers (with Token)
  Future<Map<String, dynamic>> _getHeaders({bool useToken = true}) async {
    final Map<String, dynamic> headers = {};
    if (useToken) {
      final String? token = await _getToken("accessToken");
      print("Token being sent: $token");  // Debugging
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  // Helper Method to Get Token from SharedPreferences
  Future<String?> _getToken(String key) async {
    try {
      var shared = getIt<SharedRepository>();
      var token = await shared.getData(key);
      if (token != "error") {
        return token;
      }
      return null;
    } catch (exp) {
      return null;
    }
  }
}
