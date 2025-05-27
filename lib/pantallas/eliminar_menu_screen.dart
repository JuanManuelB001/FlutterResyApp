import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EliminarMenuScreen extends StatefulWidget {
  const EliminarMenuScreen({Key? key}) : super(key: key);

  @override
  State<EliminarMenuScreen> createState() => _EliminarMenuState();
}

class _EliminarMenuState extends State<EliminarMenuScreen> {
  List<dynamic> menu = [];
  bool estaCargando = true;

  @override
  void initState() {
    super.initState();
    cargarMenu();
  }

  Future<void> cargarMenu() async {
    try {
      final response = await http.get(
        Uri.parse("https://resyapp-m4ap.onrender.com/productos/"),
      );

      if (response.statusCode == 200) {
        setState(() {
          menu = jsonDecode(response.body);
          estaCargando = false;
        });
      } else {
        throw Exception('Error al cargar menú: ${response.statusCode}');
      }
    } catch (e) {
      print("Error al conectar con la API: $e");
      setState(() {
        estaCargando = false;
      });
    }
  }

  Future<void> eliminarProductoDelMenu(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "https://resyapp-m4ap.onrender.com/productos/eliminarProducto/$id",
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await cargarMenu(); // Actualizar lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado exitosamente')),
        );
      } else {
        throw Exception('Error al eliminar: ${response.statusCode}');
      }
    } catch (e) {
      print("Error al eliminar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el producto ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Producto del Menú')),
      body:
          estaCargando
              ? const Center(child: CircularProgressIndicator())
              : menu.isEmpty
              ? const Center(child: Text('No hay productos en el menú.'))
              : ListView.builder(
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  final producto = menu[index];
                  return ListTile(
                    title: Text(producto['nombre']),
                    subtitle: Text('Precio: \$${producto['precio']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        eliminarProductoDelMenu(
                          producto['producto_id'].toString(),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
