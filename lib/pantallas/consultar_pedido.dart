import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultarPedidoScreen extends StatefulWidget {
  const ConsultarPedidoScreen({Key? key}) : super(key: key);

  @override
  State<ConsultarPedidoScreen> createState() => _ConsultarMenuState();
}

class _ConsultarMenuState extends State<ConsultarPedidoScreen> {
  List<dynamic> menu = [];
  bool estaCargando = true;

  @override
  void initState() {
    super.initState();
    cargarMenu();
  }

  cargarMenu() async {
    try {
      final urlEndPoint = await http.get(
        Uri.parse("https://resyapp-m4ap.onrender.com/pedidos/"),
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

  agregarPedido(Map producto) async {
    try {
      Map pedido = {
        "nombre": producto['nombre'],
        "descripcion": producto['descripcion'],
        "precio": producto['precio'],
        "imagen": producto['imagen'],
        "ingredientesIds":
            producto['ingredientesIds'], // Puedes adaptar esto según tu lógica real
      };

      final url = Uri.parse("https://resyapp-m4ap.onrender.com/pedidos/");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pedido),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pedido creado exitosamente')),
        );
      } else {
        throw Exception('Error al crear el pedido: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error al crear pedido: $e')));
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
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
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
