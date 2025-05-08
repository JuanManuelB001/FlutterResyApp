import 'package:flutter/material.dart';

class EliminarProductoScreen extends StatelessWidget {
  const EliminarProductoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Producto')),
      body: const Center(child: Text('Lista de productos para eliminar')),
    );
  }
}
