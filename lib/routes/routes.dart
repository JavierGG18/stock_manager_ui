import 'package:flutter/material.dart';
import 'package:stock_manager/screens/home_screen.dart';
import 'package:stock_manager/screens/product_list_screen.dart';
import 'package:stock_manager/screens/transaccion_list_screen.dart';

class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const transactions = '/transactions';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case products:
        return MaterialPageRoute(builder: (_) => ProductListScreen());
      case transactions:
        return MaterialPageRoute(builder: (_) => TransaccionListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}