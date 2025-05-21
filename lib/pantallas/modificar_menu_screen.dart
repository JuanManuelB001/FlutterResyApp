import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;

class ModificarMenuScreen extends StatefulWidget {
  const ModificarMenuScreen({Key? key}) : super(key: key);
  @override
  State<ModificarMenuScreen> createState() => _ModificarMenuState();
}

class _ModificarMenuState extends State<ModificarMenuScreen> {
  List<dynamic> menu = [];
  bool estaCargando = true;

  @override
  void initState() {
    super.initState();
    cargarMenu();
  }

  Future<void> cargarMenu() async {
    try {
      final urlEndPoint = await http.get(Uri.parse(""));
      if (urlEndPoint.statusCode == 200) {
        setState(() {
          menu = jsonDecode(urlEndPoint.body);
          estaCargando = false;
        });
      } else {
        throw Exception("Error ${urlEndPoint.statusCode}");
      }
    } catch (e) {
      print("Error  $e");
      setState(() {
        estaCargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Menú')),
      body:
          estaCargando
              ? const Center(child: CircularProgressIndicator())
              : menu.isEmpty
              ? const Center(child: Text('No hay productos disponibles.'))
              : ListView.builder(
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  final producto = menu[index];
                  return ListTile(
                    title: Text(producto['nombre'] ?? 'Nombre no disponible'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descripción: ${producto['descripcion'] ?? 'N/A'}',
                        ),
                        Text(
                          'Precio: \$${producto['precio']?.toString() ?? 'N/A'}',
                        ),
                      ],
                    ),
                    trailing: Text(
                      (producto['esAlimenticio'] ?? false) ? '🍎' : '🧃',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
    );
  }
}
