import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  String? _esAlimenticio;

  @override
  void dispose() {
    // TODO: implement dispose
    _nombreController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  void _agregarProducto() async {
    final nombre = _nombreController.text;
    final cantidad = _cantidadController.text;
    bool esAlimenticio;
    //VALIDAR T/F
    esAlimenticio = _esAlimenticio == 'Sí' ? true : false;
    print('parecedero = $esAlimenticio');
    //ENDPOINT
    final urlEndPoint = Uri.parse(
      'https://resyapp-m4ap.onrender.com/ingredientes/',
    );
    //DICCIONARIO
    Map<String, dynamic> productos = {
      "nombre": nombre,
      "cantidad": cantidad,
      "esAlimenticio": esAlimenticio,
    };
    try {
      final response = await http.post(
        urlEndPoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productos),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registro Exitoso')));
        //limpiarCampos();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error ${response.statusCode}')));
      }
    } catch (e) {
      print('Este es el error\n$e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error Ingreso Usuario')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            TextField(controller: _nombreController),
            const SizedBox(height: 20),
            const Text(
              'Cantidad',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Es alimenticio',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            DropdownButton<String>(
              value: _esAlimenticio,
              hint: const Text('Selecciona una opción'),
              items:
                  ['Sí', 'No'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _esAlimenticio = value;
                });
              },
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _agregarProducto,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
