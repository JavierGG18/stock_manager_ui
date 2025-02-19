import 'package:flutter/material.dart';
import '../models/transaccion.dart';
import '../services/transaccion_service.dart';
import '../widgets/transaccion_card.dart';

class TransaccionListScreen extends StatelessWidget {
  const TransaccionListScreen({super.key});

  Future<List<Transaccion>> _fetchTransacciones() {
    return TransaccionService().getTransacciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
      ),
      body: FutureBuilder<List<Transaccion>>(
        future: _fetchTransacciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar las transacciones: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No se encontraron transacciones',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final transacciones = snapshot.data!;
            return ListView.builder(
              itemCount: transacciones.length,
              itemBuilder: (context, index) {
                return TransaccionCard(transaccion: transacciones[index]);
              },
            );
          }
        },
      ),
    );
  }
}
