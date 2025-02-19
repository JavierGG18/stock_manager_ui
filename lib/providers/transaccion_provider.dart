import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_manager/models/transaccion.dart';
import 'package:stock_manager/services/transaccion_service.dart';

final transaccionProvider = FutureProvider<List<Transaccion>>((ref) async {
  final transaccionService = TransaccionService();
  return await transaccionService.getTransacciones();
});