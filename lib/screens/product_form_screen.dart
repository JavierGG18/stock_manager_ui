import 'package:flutter/material.dart';
import 'package:stock_manager/models/producto.dart';
import 'package:stock_manager/services/producto_service.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService productoService = ProductoService();

  // Controladores de texto para los campos
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();

  // Método para mostrar un AlertDialog
  void _mostrarDialogo(BuildContext context, String titulo, String mensaje, bool esExito) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                if (esExito) {
                  Navigator.of(context).pop(true); // Cierra la pantalla y devuelve "true"
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      // Limpiar los campos antes de crear el Producto
      final nombre = nombreController.text.trim();
      final precio = precioController.text.trim();
      final stock = stockController.text.trim();
      final marca = marcaController.text.trim();
      final categoria = categoriaController.text.trim();

      if (nombre != nombreController.text || marca != marcaController.text || categoria != categoriaController.text) {
        _mostrarDialogo(context, 'Error', 'Los campos no pueden comenzar ni terminar con espacios', false);
        return;
      }

      // Crear un nuevo objeto Producto
      final nuevoProducto = Producto(
        nombre: nombre,
        precio: double.parse(precio),
        stock: int.parse(stock),
        marca: marca,
        categoria: categoria,
        status: 1, // Por defecto, activado
      );

      try {
        final resultado = await productoService.postProducto(nuevoProducto);
        switch (resultado) {
          case 1:
            // Éxito: producto agregado
            _mostrarDialogo(context, 'Éxito', 'Producto agregado con éxito', true);
            break;
          case 0:
            // Conflicto: producto ya existe
            _mostrarDialogo(context, 'Error', 'El producto ya está registrado', false);
            break;
          case 2:
            // Datos inválidos
            _mostrarDialogo(context, 'Error', 'Datos inválidos, inténtalo de nuevo', false);
            break;
          default:
            // Otro error no manejado
            _mostrarDialogo(context, 'Error', 'Error al agregar producto', false);
        }
      } catch (e) {
        // Manejo de errores (por ejemplo, problemas de conexión)
        _mostrarDialogo(context, 'Error', 'Error al agregar producto: $e', false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número entero válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una marca';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarProducto,
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}