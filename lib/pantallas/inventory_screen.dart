import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Producto'),
              onPressed: () {
                Navigator.pushNamed(context, '/agregar');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Gestionar Producto'),
              onPressed: () {
                Navigator.pushNamed(context, '/gestionar');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Eliminar Producto'),
              onPressed: () {
                Navigator.pushNamed(context, '/eliminar');
              },
            ),
          ],
        ),
      ),
    );
  }
}
