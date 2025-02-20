import 'package:flutter/material.dart';
import 'package:stock_manager/screens/home_screen.dart';
import 'package:stock_manager/screens/product_list_screen.dart';
import 'package:stock_manager/screens/transaccion_list_screen.dart';
import 'package:stock_manager/screens/product_form_screen.dart';

class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const transactions = '/transactions';
  static const productForm = '/productForm';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case transactions:
        return MaterialPageRoute(builder: (_) => const TransaccionListScreen());
      case productForm:
        return MaterialPageRoute(builder: (_) => const ProductFormScreen());
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