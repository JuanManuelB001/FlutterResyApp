import 'package:flutter/material.dart';

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
                onPressed: () {
                  // Aquí se guardaría el producto (por implementar)
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
