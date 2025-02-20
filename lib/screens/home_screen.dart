import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager/providers/producto_provider.dart';
import 'package:stock_manager/routes/routes.dart';
import 'package:stock_manager/widgets/product_card.dart';
import 'package:stock_manager/screens/stock_in_screen.dart';
import 'package:stock_manager/screens/stock_out_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    // Formato para fecha actual
    String formattedDate = DateFormat('EEE, MMM d').format(DateTime.now());

    final productosAsyncValue = ref.watch(productoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Manager',
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
            productosAsyncValue.when(
              data: (productos) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatisticBox(title: 'items', value: '${productos.length}'),
                    _ActionBox(
                      title: 'Stock In',
                      iconColor: Colors.green,
                      icon: Icons.arrow_downward,
                      onTap: () {
                        // Navegar a la pantalla Stock In
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StockInScreen()),
                        );
                      },
                    ),
                    _ActionBox(
                      title: 'Stock Out',
                      iconColor: Colors.red,
                      icon: Icons.arrow_upward,
                      onTap: () {
                        // Navegar a la pantalla Stock Out
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StockOutScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
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
                    controller: _scrollController,
                    itemCount: _currentMax <= productos.length ? _currentMax + 1 : productos.length,
                    itemBuilder: (context, index) {
                      if (index == _currentMax) {
                        return const Center(child: CircularProgressIndicator());
                      }
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
      height: 100, // Añadido para establecer la misma altura
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

class _ActionBox extends StatelessWidget {
  final String title;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBox({
    required this.title,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100, // Añadido para establecer la misma altura
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black), // Reducción del tamaño del texto y color negro
            ),
          ],
        ),
      ),
    );
  }
}