import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ResyApp',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/burger.jpg',
              height: 150,
            ), // Asegúrate de tener esta imagen
            const SizedBox(height: 24),
            const Text('Usuario', style: TextStyle(color: Colors.red)),
            const Text('Jramirezl', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Contraseña', style: TextStyle(color: Colors.red)),
            const Text('********', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/menu');
              },
              child: const Text('Ingresar'),
            ),
            const TextButton(
              onPressed: null,
              child: Text(
                'Olvide mi contraseña',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
