import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GestionarProductoScreen extends StatefulWidget {
  const GestionarProductoScreen({super.key});

  @override
  State<GestionarProductoScreen> createState() =>
      _GestionarProductoScreenState();
}

class _GestionarProductoScreenState extends State<GestionarProductoScreen> {
  List<dynamic> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      final urlEndPoint = await http.get(
        Uri.parse("https://resyapp-m4ap.onrender.com/ingredientes/"),
      );
      // VALIDAR RESPUESTA DE SERVIDOR
      if (urlEndPoint.statusCode == 200) {
        setState(() {
          productos = jsonDecode(urlEndPoint.body);
          isLoading = false;
        });
      } else {
        throw Exception('Error ${urlEndPoint.statusCode}');
      }
    } catch (e) {
      print('Error al obtener productos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar productos')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : productos.isEmpty
              ? const Center(child: Text('No hay productos disponibles.'))
              : ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return ListTile(
                    title: Text(producto['nombre']),
                    subtitle: Text('Cantidad: ${producto['cantidad']}'),
                    trailing: Text(producto['esAlimenticio'] ? '🍎' : '🧃'),
                  );
                },
              ),
    );
  }
}
