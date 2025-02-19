class Transaccion {
  final int transaccionId;
  final DateTime fecha;
  final String accion;
  final String nombreProducto;
  final String nombreCategoria;
  final int cantidad;
  final double costo;

  Transaccion({
    required this.transaccionId,
    required this.fecha,
    required this.accion,
    required this.nombreProducto,
    required this.nombreCategoria,
    required this.cantidad,
    required this.costo,
  });

  // Método para crear una instancia de Transaccion a partir de un JSON
  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      transaccionId: json['transaccionId'],
      fecha: DateTime.parse(json['fecha']),
      accion: json['accion'],
      nombreProducto: json['nombreProducto'],
      nombreCategoria: json['nombreCategoria'],
      cantidad: json['cantidad'],
      costo: json['costo'].toDouble(),
    );
  }
}
