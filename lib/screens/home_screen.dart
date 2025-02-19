import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager/providers/producto_provider.dart';
import 'package:stock_manager/routes/routes.dart';
import 'package:stock_manager/widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //formato para fecha actual
    String formattedDate = DateFormat('EEE, MMM d').format(DateTime.now());

    final productosAsyncValue = ref.watch(productoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hola',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Javier García',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Hoy $formattedDate',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatisticBox(title: 'Total', value: '221'),
                _StatisticBox(title: 'Stock In', value: '319'),
                _StatisticBox(title: 'Stock Out', value: '98'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Riverpod Consumer
            Expanded(
              child: productosAsyncValue.when(
                data: (productos) {
                  if (productos.isEmpty) {
                    return const Center(child: Text('No se encontraron productos.'));
                  }
                  return ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      return ProductCard(producto: productos[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transacciones',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          if (index == 1) {
            // Navegar a la pantalla de lista de productos
            Navigator.pushNamed(context, AppRoutes.products);
          } else if (index == 2) {
            // Navegar a la pantalla de lista de transacciones
            Navigator.pushNamed(context, AppRoutes.transactions);
          }
        },
      ),
    );
  }
}

class _StatisticBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatisticBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}