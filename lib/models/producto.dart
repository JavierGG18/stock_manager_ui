class Producto {
  final String nombre;
  final double precio;
  final int stock;
  final String marca;
  final String categoria;
  final int status;

  Producto({
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.marca,
    required this.categoria,
    required this.status,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      nombre: json['nombre'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      marca: json['marca'],
      categoria: json['categoria'],
      status: json['status'],
    );
  }

  // Método para generar el slug a partir del nombre del producto
  String getSlug() {
    return nombre
        .toLowerCase() // Convertir a minúsculas
        .replaceAll(RegExp(r'\s+'), '-') // Reemplazar espacios por guiones
        .replaceAll(RegExp(r'[^\w\-]'), ''); // Eliminar caracteres no alfanuméricos
  }
}

