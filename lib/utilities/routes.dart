import 'package:flutter/material.dart';
import 'package:wejoeco/views/client/Supplier.dart';
import 'package:wejoeco/views/client/AddProductScreen.dart';
import 'package:wejoeco/views/client/Market.dart';
import 'package:wejoeco/views/client/ProfileScreen.dart';
import '../views/admin/CustomerScreen.dart';
import '../views/admin/PercentageScreen.dart';
import '../views/admin/SupplierScreenAdmin.dart';
import '../views/client/Cart_Screen.dart';
import '../views/client/DashBordScreen.dart';
import '../main.dart';
import '../views/client/Totalprofit.dart'; // Import main.dart to access _HomeScreen

class Routes {
  static const String home = '/home'; // Add home route for _HomeScreen
  static const String dashboard = '/';
  static const String supplier = '/supplier';
  static const String addProduct = '/addProduct';
  static const String market = '/market';
  static const String profile = '/profile';
  static const String cart = '/cart';
  static const String PercentageScreen = '/percentageScreen';
  static const String Totalprofit = '/Totalprofit';
  static const String SupplerScreen = '/SupplerScreen';
  static const String CustomerScreen = '/CustomerScreen';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.supplier:
        return MaterialPageRoute(builder: (_) => const Supplier());
      case Routes.addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case Routes.market:
        return MaterialPageRoute(builder: (_) => const Market());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashBoardScreen());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case Routes.PercentageScreen:
        return MaterialPageRoute(builder: (_) => PercentageScreen());
      case Routes.Totalprofit: // Add this case
        return MaterialPageRoute(builder: (_) => const TotalProfit());
      case Routes.CustomerScreen: // Add this case
        return MaterialPageRoute(builder: (_) =>  CustomerScreenBody());

           case Routes.SupplerScreen: // Add this case
        return MaterialPageRoute(builder: (_) => const SupplierScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}