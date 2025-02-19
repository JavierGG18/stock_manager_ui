import 'package:dio/dio.dart';
import 'package:stock_manager/models/producto.dart';

class ProductoService {
  final Dio dio = Dio();

  Future<List<Producto>> getProductos() async {
    try {
      // Realizamos la solicitud GET al endpoint
      final response = await dio.get('http://localhost:5166/productos');

      if (response.statusCode == 200) {
        // Decodificamos la respuesta en formato JSON y la convertimos a objetos Producto
        List<dynamic> data = response.data;
        return data.map((item) => Producto.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }
}

