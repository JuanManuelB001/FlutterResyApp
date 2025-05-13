import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EliminarProductoScreen extends StatefulWidget {
  const EliminarProductoScreen({Key? key}) : super(key: key);

  @override
  State<EliminarProductoScreen> createState() => _EliminarProductoState();
}

class _EliminarProductoState extends State<EliminarProductoScreen> {
  List<dynamic> productos = [];
  bool estaCargando = true;

  @override
  void initState() {
    super.initState();
    fetchProducto();
  }

  Future<void> fetchProducto() async {
    try {
      final urlEndPoint = await http.get(
        Uri.parse("https://resyapp-m4ap.onrender.com/ingredientes/"),
      );
      if (urlEndPoint.statusCode == 200) {
        setState(() {
          productos = jsonDecode(urlEndPoint.body);
          estaCargando = false;
        });
      } else {
        throw Exception('Error ${urlEndPoint.statusCode}');
      }
    } catch (e) {
      print("Error $e");
      setState(() {
        estaCargando = false;
      });
    }
  }

  Future<void> eliminarProducto(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "https://resyapp-m4ap.onrender.com/ingredientes/eliminar/$id",
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchProducto(); // Recarga desde el servidor
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado exitosamente')),
        );
      } else {
        throw Exception('Error al eliminar: ${response.statusCode}');
      }
    } catch (e) {
      print("Error al eliminar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar productos')),
      body:
          estaCargando
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(producto['esAlimenticio'] ? '🍎' : '🧃'),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            eliminarProducto(producto['id'].toString());
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
