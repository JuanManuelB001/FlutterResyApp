import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

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
  final _precioController = TextEditingController();

  Uint8List? _imagenBytes;
  String? _nombreArchivo;

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

  Future<void> _seleccionarImagenWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imagenBytes = result.files.single.bytes;
        _nombreArchivo = result.files.single.name;
        print('ARchivo selecionado $_nombreArchivo');
      });
    }
  }

  Future<void> _agregarProductoMenu() async {
    final nombre = _nombreController.text;
    final descripcion = _descripcionController.text;
    final precio = double.tryParse(_precioController.text);

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        precio == null ||
        _imagenBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // En este punto, puedes convertir la imagen a base64 si deseas enviarla como texto:
    //final imagenBase64 = base64Encode(_imagenBytes!);

    final producto = {
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "imagen": _nombreArchivo,
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
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _seleccionarImagenWeb,
              icon: const Icon(Icons.image),
              label: const Text('Seleccionar Imagen'),
            ),
            if (_imagenBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.memory(_imagenBytes!, height: 150),
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
