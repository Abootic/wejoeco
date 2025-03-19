import 'package:flutter/material.dart';
import 'package:wejoeco/views/client/Supplier.dart';
import 'package:wejoeco/views/client/AddProductScreen.dart';
import 'package:wejoeco/views/client/Market.dart';
import 'package:wejoeco/views/client/ProfileScreen.dart';

import '../views/client/Cart_Screen.dart';
import '../views/client/DashBordScreen.dart';

class Routes {
  static const String profile = '/';
  static const String supplier = '/supplier';
  static const String addProduct = '/addProduct';
  static const String market = '/market';
  static const String dashboard = '/dashboard';  // Route for DashBoardScreen
  static const String cart = '/cart';  // Route for CartScreen
}


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.supplier:
        return MaterialPageRoute(builder: (_) => const Supplier());
      case Routes.addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case Routes.market:
        return MaterialPageRoute(builder: (_) => const Market());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashBoardScreen());  // DashBoardScreen route
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());  // CartScreen route
      default:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
    }
  }
}
