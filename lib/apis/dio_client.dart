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
    _cacheStore = HiveCacheStore(_getCachePath());

    final cacheOptions = CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 10),
      hitCacheOnErrorExcept: [401, 403],
    );

    _cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

    _dio
      ..options.baseUrl = Urls.BaseUrl
      ..options.connectTimeout = Duration(milliseconds: Urls.connectionTimeout)
      ..options.receiveTimeout = Duration(milliseconds: Urls.receiveTimeout)
      ..options.responseType = ResponseType.json
      ..interceptors.add(_cacheInterceptor);
  }

  String _getCachePath() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Directory.systemTemp.path + '/cache';
    }
    return './cache';
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  Future<bool> clearCache() async {
    try {
      await _cacheStore.clean();
      return true;
    } catch (e) {
      print("Error clearing cache: ${e.toString()}");
      return false;
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool useCache = true,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        await _cacheStore.delete(Uri.parse(url) as String);
      }

      options =
          options?.copyWith(headers: await _getHeaders()) ??
          Options(headers: await _getHeaders());

      final cacheOptions = CacheOptions(
        policy: useCache ? CachePolicy.forceCache : CachePolicy.refresh,
        maxStale: const Duration(seconds: Urls.maxStale),
        store: _cacheStore,
      );

      print("Cache cleared for GET request: $url");

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: useCache ? cacheOptions.toOptions() : options,
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
      options =
          options?.copyWith(headers: await _getHeaders(useToken: useToken)) ??
          Options(headers: await _getHeaders(useToken: useToken));

      print("POST Request URI: $uri");
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
        await clearCache();
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Dio client POST: $e");
      }
      rethrow;
    }
  }

  /// **PUT Request (Update)**
  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool clearCacheAfterPut = false,
    bool useToken = true,
  }) async {
    try {
      options =
          options?.copyWith(headers: await _getHeaders(useToken: useToken)) ??
          Options(headers: await _getHeaders(useToken: useToken));

      print("PUT Request URI: $uri");
      print("PUT Data: ${jsonEncode(data)}");

      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (clearCacheAfterPut) {
        await clearCache();
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Dio client PUT: $e");
      }
      rethrow;
    }
  }

  /// **DELETE Request**
  Future<Response> delete(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool clearCacheAfterDelete = true,
    bool useToken = true,
  }) async {
    try {
      options =
          options?.copyWith(headers: await _getHeaders(useToken: useToken)) ??
          Options(headers: await _getHeaders(useToken: useToken));

      print("DELETE Request URI: $uri");

      final Response response = await _dio.delete(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (clearCacheAfterDelete) {
        await clearCache();
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Dio client DELETE: $e");
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getHeaders({bool useToken = true}) async {
    final Map<String, dynamic> headers = {};
    if (useToken) {
      final String? token = await _getToken("accessToken");
      print("Token being sent: $token");
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  Future<String?> _getToken(String key) async {
    try {
      var shared = getIt<SharedRepository>();
      var token = await shared.getData(key);
      return token != "error" ? token : null;
    } catch (exp) {
      return null;
    }
  }
}
