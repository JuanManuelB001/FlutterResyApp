import 'package:flutter/material.dart';

class CrearUsuarioScreen extends StatelessWidget {
  const CrearUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Nombre')),
            const TextField(decoration: InputDecoration(labelText: 'Usuario')),
            const TextField(decoration: InputDecoration(labelText: 'Rol')),
            const TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
