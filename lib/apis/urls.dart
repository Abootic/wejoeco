import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class Urls {
  Urls._();

  //============== constant configs ===============
  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 30000;
  static const int maxAge = 86400;
  static const int maxStale = 604800;

  //====================== constant Urls ======================
  static const String BaseUrl = "http://127.0.0.1:8000/api";
  //static const String BaseUrl = "http://localhost:8000/api";
  static const String Host = "localhost";
  static const String Port = ":8000";
  static const String Markets = "/markets/";
  static const String Suppliers = "/suppliers/";
  static const String Get_Supplier_by_UserId =Suppliers+ "get_supplier_by_UserId/";
  static const String Customers = "/customers/";
  static const String Products = "/products/";

  static const String Useraccess = "/useraccess";
  static const String Login = Useraccess + "/login/";


  // Cache configuration
  static Future<CacheOptions> getCacheOptions() async {
    final dir = await getApplicationDocumentsDirectory();
    return CacheOptions(
      store: HiveCacheStore(dir.path),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      hitCacheOnErrorExcept: [401, 403],
    );
  }
}
