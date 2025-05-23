import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarProductoScreen extends StatefulWidget {
  final Map<String, dynamic> producto;

  const EditarProductoScreen({Key? key, required this.producto})
    : super(key: key);

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;
  bool esAlimenticio = false;
  bool modificarImagen = false;
  late String idProducto;
  String? _nombreArchivo;
  List<dynamic> todosIngredientes = [];
  List<int> ingredientesSeleccionados = [];

  @override
  void initState() {
    super.initState();
    idProducto = widget.producto['producto_id'].toString();
    nombreController = TextEditingController(text: widget.producto['nombre']);
    descripcionController = TextEditingController(
      text: widget.producto['descripcion'],
    );
    precioController = TextEditingController(
      text: widget.producto['precio'].toString(),
    );
    esAlimenticio = widget.producto['esAlimenticio'] ?? false;

    // Cargar ingredientes
    cargarIngredientes();

    // Cargar ingredientes ya seleccionados del producto (si están presentes)
    if (widget.producto.containsKey('ingredientes')) {
      ingredientesSeleccionados = List<int>.from(
        (widget.producto['ingredientes'] as List<dynamic>).map(
          (item) => item['id'],
        ),
      );
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  Future<void> cargarIngredientes() async {
    final response = await http.get(
      Uri.parse('https://resyapp-m4ap.onrender.com/ingredientes/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        todosIngredientes = jsonDecode(response.body);
      });
    } else {
      print("Error al cargar ingredientes: ${response.statusCode}");
    }
  }

  Future<void> _seleccionarImagenWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _nombreArchivo = result.files.single.name;
        print('ARchivo selecionado $_nombreArchivo');
        modificarImagen = true;
      });
    }
  }

  Future<void> guardarCambios() async {
    final url = Uri.parse(
      'https://resyapp-m4ap.onrender.com/productos/actualizar/$idProducto',
    );

    final respuesta = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'precio': double.tryParse(precioController.text) ?? 0.0,
        'imagen':
            modificarImagen == true
                ? _nombreArchivo
                : widget.producto['imagen'],
        'ingredientesIds': ingredientesSeleccionados,
      }),
    );

    print("id: $idProducto");
    print("Nombre: ${nombreController.text}");
    print("Descripción: ${descripcionController.text}");
    print("Precio: ${precioController.text}");
    print("Ingredientes: $ingredientesSeleccionados");

    if (respuesta.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto actualizado correctamente")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar: ${respuesta.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _seleccionarImagenWeb,
              icon: const Icon(Icons.image),
              label: const Text('Seleccionar Imagen'),
            ),
            SwitchListTile(
              title: const Text("¿Es alimenticio?"),
              value: esAlimenticio,
              onChanged: (valor) {
                setState(() {
                  esAlimenticio = valor;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Selecciona Ingredientes:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todosIngredientes.length,
                itemBuilder: (context, index) {
                  final ingrediente = todosIngredientes[index];
                  final id = ingrediente['id'] as int;
                  final nombre = ingrediente['nombre'];

                  return CheckboxListTile(
                    title: Text(nombre),
                    value: ingredientesSeleccionados.contains(id),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          ingredientesSeleccionados.add(id);
                        } else {
                          ingredientesSeleccionados.remove(id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: guardarCambios,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
