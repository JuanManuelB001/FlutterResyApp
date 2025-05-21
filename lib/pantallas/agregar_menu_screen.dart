import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarMenuScreen extends StatefulWidget {
  const AgregarMenuScreen({Key? key}) : super(key: key);

  @override
  State<AgregarMenuScreen> createState() => _AgregarMenuState();
}

class Ingrediente {
  final int id;
  final String nombre;

  Ingrediente({required this.id, required this.nombre});
  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(id: json['id'], nombre: json['nombre']);
  }
}

class _AgregarMenuState extends State<AgregarMenuScreen> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _imagenController = TextEditingController();
  final _precioController = TextEditingController();

  List<Ingrediente> _ingredientesDisponibles = [];
  List<int> _ingredientesSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _cargarIngredientes();
  }

  Future<void> _cargarIngredientes() async {
    final url = Uri.parse('https://resyapp-m4ap.onrender.com/ingredientes/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _ingredientesDisponibles =
              data.map((e) => Ingrediente.fromJson(e)).toList();
        });
      } else {
        print('Error al cargar ingredientes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectar con la API: $e');
    }
  }

  Future<void> _agregarProductoMenu() async {
    final nombre = _nombreController.text;
    final descripcion = _descripcionController.text;
    final precio = double.tryParse(_precioController.text);
    final imagen = _imagenController.text;

    if (nombre.isEmpty || descripcion.isEmpty || precio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final producto = {
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "imagen": imagen,
      "ingredientesIds": _ingredientesSeleccionados,
    };

    final url = Uri.parse('https://resyapp-m4ap.onrender.com/productos/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(producto),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado exitosamente')),
        );
      } else {
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error en la petición: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error de conexión')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto al Menú')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto',
              ),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imagenController,
              decoration: const InputDecoration(labelText: 'Imagen'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selecciona Ingredientes:',
              style: TextStyle(fontSize: 16),
            ),
            Wrap(
              spacing: 5,
              children:
                  _ingredientesDisponibles.map((ingrediente) {
                    final isSelected = _ingredientesSeleccionados.contains(
                      ingrediente.id,
                    );
                    return FilterChip(
                      label: Text(ingrediente.nombre),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _ingredientesSeleccionados.add(ingrediente.id);
                          } else {
                            _ingredientesSeleccionados.remove(ingrediente.id);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _agregarProductoMenu,
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}
