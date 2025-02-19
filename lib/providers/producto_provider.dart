import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_manager/models/producto.dart';
import 'package:stock_manager/services/producto_service.dart';

final productoProvider = FutureProvider<List<Producto>>((ref) async {
  final productoService = ProductoService();
  return await productoService.getProductos();
});