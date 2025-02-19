import 'package:flutter/material.dart';
import 'package:stock_manager/models/producto.dart';
import 'package:stock_manager/services/producto_service.dart';
import 'package:stock_manager/widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  final ProductoService productoService = ProductoService();

   ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Productos'),
      ),
      body: FutureBuilder<List<Producto>>(
        future: productoService.getProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final productos = snapshot.data!;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return ProductCard(producto: producto);
            },
          );
        },
      ),
    );
  }
}
