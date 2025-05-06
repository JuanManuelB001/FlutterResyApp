import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ResyApp')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jramirezl',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text('Admin 1', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(title: const Text('Inventario'), onTap: () {}),
            ListTile(
              title: const Text('Gestión de usuarios'),
              onTap: () {
                Navigator.pushNamed(context, '/gestion');
              },
            ),
            ListTile(title: const Text('Configuraciones'), onTap: () {}),
          ],
        ),
      ),
      body: const Center(child: Text('Bienvenido a ResyApp')),
    );
  }
}
