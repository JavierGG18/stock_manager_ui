import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_manager/models/transaccion.dart';
import 'package:stock_manager/providers/transaccion_provider.dart';
import 'package:stock_manager/widgets/transaccion_card.dart';

class TransaccionListScreen extends ConsumerStatefulWidget {
  const TransaccionListScreen({super.key});

  @override
  _TransaccionListScreenState createState() => _TransaccionListScreenState();
}

class _TransaccionListScreenState extends ConsumerState<TransaccionListScreen> {
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
    final transaccionesAsyncValue = ref.watch(transaccionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
      ),
      body: transaccionesAsyncValue.when(
        data: (transacciones) {
          if (transacciones.isEmpty) {
            return const Center(child: Text('No se encontraron transacciones.'));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: _currentMax <= transacciones.length ? _currentMax + 1 : transacciones.length,
            itemBuilder: (context, index) {
              if (index == _currentMax) {
                return const Center(child: CircularProgressIndicator());
              }
              return TransaccionCard(transaccion: transacciones[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}