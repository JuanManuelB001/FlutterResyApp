import 'package:flutter/material.dart';

class GestionMenuScreen extends StatelessWidget {
  const GestionMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Menú')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // Agrega algo de padding alrededor
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/agregar_menu');
                },
                child: const Text('Agregar Producto al Menú'),
              ),
              const SizedBox(height: 16), // Espacio entre botones

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/consultar_menu');
                },
                child: const Text('Consultar Menú'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/modificar_menu');
                },
                child: const Text('Modificar Producto del Menú'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/eliminar_menu');
                },
                child: const Text('Eliminar Producto del Menú'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
