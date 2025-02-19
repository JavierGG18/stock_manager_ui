import 'package:flutter/material.dart';
import '../models/transaccion.dart';

class TransaccionCard extends StatelessWidget {
  final Transaccion transaccion;

  const TransaccionCard({
    super.key,
    required this.transaccion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transacción: ${transaccion.transaccionId}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Fecha: ${transaccion.fecha.toString()}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Acción: ${transaccion.accion}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getAccionColor(transaccion.accion),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Producto: ${transaccion.nombreProducto}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Categoría: ${transaccion.nombreCategoria}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Cantidad: ${transaccion.cantidad}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Costo: \$${transaccion.costo.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para asignar color según el tipo de acción
  Color _getAccionColor(String accion) {
    switch (accion.toUpperCase()) {
      case 'ENTRADA':
        return Colors.green;
      case 'SALIDA':
        return Colors.red;
      case 'NUEVO PRODUCTO':
        return Colors.blue;
      case 'CAMBIO DE ESTATUS':
      case 'DESCONTINUAR PRODUCTO':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}
