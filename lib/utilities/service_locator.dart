
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';


import '../apis/dio_client.dart';
import '../repositories/CustomerRepository.dart';
import '../repositories/LoginRepository.dart';
import '../repositories/MarketRepository.dart';
import '../repositories/ProductRepository.dart';
import '../repositories/SharedRepository.dart';
import '../repositories/SupplierRepository.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  //============ Apis Services ===================
  //getIt.registerSingleton(ExampleApi(dioClient: getIt<DioClient>()));

  getIt.registerSingleton(SharedRepository());
  getIt.registerSingleton(MarketRepository(getIt.get<DioClient>()));
  getIt.registerSingleton(SupplierRepository(getIt.get<DioClient>()));
  getIt.registerSingleton(CustomerRepository(getIt.get<DioClient>()));
  getIt.registerSingleton(LoginRepository(getIt.get<DioClient>()));
  getIt.registerSingleton(ProductRepository(getIt.get<DioClient>()));

  //============= Repositories Services =================
  //getIt.registerSingleton(ExampleRepository(getIt.get<ExampleApi>()));
 /* getIt.registerSingleton(CollegesRepository(getIt.get<DioClient>()));
 */

}
