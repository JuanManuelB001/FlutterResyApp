import 'package:flutter/material.dart';

class GestionUsuariosScreen extends StatelessWidget {
  const GestionUsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/crear'),
              child: const Text('Crear nuevo usuario'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/modificar'),
              child: const Text('Modificar usuario'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {},
              child: const Text('Eliminar usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
