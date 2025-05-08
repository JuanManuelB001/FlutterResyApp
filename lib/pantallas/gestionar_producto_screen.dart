import 'package:flutter/material.dart';

class GestionarProductoScreen extends StatelessWidget {
  const GestionarProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar productos')),
      body: const Center(child: Text('No hay productos disponibles.')),
    );
  }
}
