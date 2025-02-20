import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_manager/providers/producto_provider.dart';
import 'package:stock_manager/services/producto_service.dart';

class StockOutScreen extends ConsumerStatefulWidget {
  const StockOutScreen({super.key});

  @override
  _StockOutScreenState createState() => _StockOutScreenState();
}

class _StockOutScreenState extends ConsumerState<StockOutScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    setState(() {
      _currentMax = _currentMax + 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productosAsyncValue = ref.watch(productoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Out',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productosAsyncValue.when(
          data: (productos) => ListView.builder(
            controller: _scrollController,
            itemCount: _currentMax <= productos.length ? _currentMax + 1 : productos.length,
            itemBuilder: (context, index) {
              if (index == _currentMax) {
                return const Center(child: CircularProgressIndicator());
              }
              final producto = productos[index];
              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text('Cantidad: ${producto.stock}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    // Mostrar diálogo para ingresar la cantidad
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController _cantidadController = TextEditingController();
                        return AlertDialog(
                          title: const Text('Ingresar cantidad'),
                          content: TextField(
                            controller: _cantidadController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: 'Cantidad'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Aceptar'),
                              onPressed: () async {
                                final int? cantidad = int.tryParse(_cantidadController.text);
                                if (cantidad == null || cantidad <= 0) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text('Por favor, ingrese una cantidad válida y positiva.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                if (cantidad > producto.stock) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text('La cantidad no puede ser mayor al stock disponible.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                final productoService = ProductoService();
                                final success = await productoService.updateStock(producto.getSlug(), cantidad, 'SALIDA');

                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(success ? 'Éxito' : 'Error'),
                                      content: Text(success
                                          ? 'Stock actualizado exitosamente.'
                                          : 'Error al actualizar el stock.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            if (success) {
                                              ref.refresh(productoProvider); // Refrescar la lista de productos
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}