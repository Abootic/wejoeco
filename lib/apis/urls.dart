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
  static const String BaseUrl = "http://127.0.0.1:8008/api"; // Ensure this is the correct base URL
  static const String Host = "localhost";
  static const String Port = ":8008";
  static const String Markets = "/markets/";
  static const String Suppliers = "/suppliers/";
  static const String Get_Supplier_by_UserId = Suppliers + "get_supplier_by_UserId/";
  static const String Customers = "/customers/";
  static const String Products = "/products/";
  static const String Orders = "/orders/";
  static const String Percentage = "/percentage/";
  static const String assign_percentage_value_to_suppliers = Percentage+"assign_percentage_value_to_suppliers/";
  static const String Get_Customer_Order = Orders + "get_customer_order/";
  static const String get_supplier_profit = Orders + "get_supplier_profit/";
  static const String Supplierprofit =  "/supplierprofit/";

  //static const String CalculateMarketProfit = Supplierprofit + "get_supplier_profit/";

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

  // Method to get the full URL for markets
  static String get marketsUrl => BaseUrl + Markets;
}
