import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pantallas/EditarUsuarioScreen.dart';

class ModificarUsuarioScreen extends StatefulWidget {
  const ModificarUsuarioScreen({Key? key}) : super(key: key);

  @override
  State<ModificarUsuarioScreen> createState() => _ModificarUsuarioScreenState();
}

class _ModificarUsuarioScreenState extends State<ModificarUsuarioScreen> {
  List<dynamic> usuarios = [];
  bool estaCargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://resyapp-m4ap.onrender.com/rest/",
        ), // Asegúrate de que este endpoint sea correcto
      );
      if (response.statusCode == 200) {
        setState(() {
          usuarios = jsonDecode(response.body);
          estaCargando = false;
        });
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      print("Error al cargar usuarios: $e");
      setState(() {
        estaCargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuarios')),
      body:
          estaCargando
              ? const Center(child: CircularProgressIndicator())
              : usuarios.isEmpty
              ? const Center(child: Text('No hay usuarios disponibles.'))
              : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(usuario['usuario'] ?? 'Sin usuario'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: ${usuario['nombre'] ?? ''} ${usuario['apellido'] ?? ''}',
                        ),
                        Text('Cédula: ${usuario['cedula'] ?? 'N/A'}'),
                        Text('Rol: ${usuario['rol'] ?? 'N/A'}'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditarUsuarioScreen(usuario: usuario),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
