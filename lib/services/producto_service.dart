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

  Future<int> postProducto(Producto producto) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://localhost:5166/productos',
        data: producto.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Si la solicitud es exitosa (statusCode == 200)
      if (response.statusCode == 200) {
        return 1; // Éxito
      } else {
        // Si el statusCode no es 200, devolvemos -1 (esto no debería ocurrir si Dio captura los errores)
        return -1;
      }
    } on DioException catch (e) {
      // Manejo de errores de Dio
      if (e.response != null) {
        // Verificamos el statusCode desde la excepción
        switch (e.response!.statusCode) {
          case 409:
            return 0; // Conflicto (producto ya existe)
          case 422:
            return 2; // Entidad no procesable (datos inválidos)
          default:
            return -1; // Otro código de estado no manejado
        }
      } else {
        // Si no hay respuesta del servidor (por ejemplo, error de conexión)
        throw Exception('Error al enviar el producto: ${e.message}');
      }
    }
  }

  Future<bool> updateStock(String slug, int cantidad, String movimiento) async {
    try {
      final response = await dio.patch(
        'http://localhost:5166/productos/$slug/stock',
        data: {
          'cantidad': cantidad,
          'movimiento': movimiento,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al actualizar el stock: $e');
    }
  }
}