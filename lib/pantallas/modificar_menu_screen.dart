import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pantallas/EditarProductoScreen.dart';
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
      final urlEndPoint = await http.get(
        Uri.parse("https://resyapp-m4ap.onrender.com/productos/"),
      );
      if (urlEndPoint.statusCode == 200) {
        setState(() {
          menu = jsonDecode(urlEndPoint.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modificar Menú')),
      body:
          estaCargando
              ? const Center(child: CircularProgressIndicator())
              : menu.isEmpty
              ? const Center(child: Text('No hay productos disponibles.'))
              : ListView.builder(
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  final producto = menu[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final actualizado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EditarProductoScreen(producto: producto),
                          ),
                        );
                        if (actualizado == true) {
                          cargarMenu(); // recargar menú si fue actualizado
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Producto actualizado"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                producto['imagen'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Información
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto['nombre'] ??
                                        'Nombre no disponible',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Descripción: ${producto['descripcion'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Precio: \$${producto['precio']?.toString() ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Icono
                            Text(
                              (producto['esAlimenticio'] ?? false)
                                  ? '🍎'
                                  : '🧃',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
