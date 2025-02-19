import 'package:dio/dio.dart';
import 'package:stock_manager/models/transaccion.dart';

class TransaccionService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:5166";

  // Método para obtener la lista de transacciones
  Future<List<Transaccion>> getTransacciones() async {
    try {
      // Realizamos la solicitud GET
      final response = await _dio.get('$baseUrl/transacciones');

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, mapeamos los datos a objetos Transaccion
        List<dynamic> data = response.data;
        return data.map((json) => Transaccion.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las transacciones');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
}