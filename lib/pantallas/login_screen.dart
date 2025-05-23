import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool cargando = false;

  Future<void> _login() async {
    final usuario = usuarioController.text.trim();
    final contrasena = contrasenaController.text;

    if (usuario.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena todos los campos")),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://resyapp-m4ap.onrender.com/rest/"),
        headers: {'Content-Type': 'application/json'},
        // Aquí está corregido: nombreUsuario en vez de usuario
        body: jsonEncode({'nombreUsuario': usuario, 'contrasena': contrasena}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Asegúrate de que el backend te devuelve el rol
        final String rol = (data['rol'] ?? '').toString().toUpperCase();

        if (rol == 'ADMIN') {
          Navigator.pushReplacementNamed(context, '/menu');
        } else if (rol == 'MESERO') {
          Navigator.pushReplacementNamed(context, '/mesero');
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Rol no reconocido")));
        }
      } else {
        print('Error ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de red: $e")));
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

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
            Image.asset('assets/burger.jpg', height: 120, width: 120),
            const SizedBox(height: 24),
            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                labelStyle: TextStyle(color: Colors.red),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.red),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cargando ? null : _login,
              child:
                  cargando
                      ? const CircularProgressIndicator()
                      : const Text('Ingresar'),
            ),
            TextButton(
              onPressed: () {
                // lógica para recuperar contraseña
              },
              child: const Text(
                'Olvidé mi contraseña',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
