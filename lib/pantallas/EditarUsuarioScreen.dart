import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarUsuarioScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const EditarUsuarioScreen({Key? key, required this.usuario})
      : super(key: key);

  @override
  State<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController cedulaController;
  late TextEditingController usuarioController;
  late TextEditingController contrasenaController;
  String? rolSeleccionado;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(text: widget.usuario['nombre']);
    apellidoController = TextEditingController(text: widget.usuario['apellido']);
    cedulaController = TextEditingController(text: widget.usuario['cedula']);
    usuarioController = TextEditingController(text: widget.usuario['nombreUsuario']); // ✅ cambio aquí
    contrasenaController = TextEditingController(); // En blanco si no se quiere cambiar
    rolSeleccionado = widget.usuario['rol'];
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> guardarCambios() async {
    final idUsuario = widget.usuario['usuario_id'];
    final url = Uri.parse(
      'https://resyapp-m4ap.onrender.com/rest/usuario/$idUsuario/actualizar',
    );

    final Map<String, dynamic> datosActualizados = {
      'nombre': nombreController.text,
      'apellido': apellidoController.text,
      'cedula': cedulaController.text,
      'nombreUsuario': usuarioController.text, // ✅ corrección aquí
      'rol': rolSeleccionado,
    };

    if (contrasenaController.text.isNotEmpty) {
      datosActualizados['contrasena'] = contrasenaController.text;
    }

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datosActualizados),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: usuarioController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de Usuario',
                ),
              ),
              TextField(
                controller: contrasenaController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña (dejar en blanco para no cambiar)',
                ),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: rolSeleccionado,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: const [
                  DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
                  DropdownMenuItem(value: 'MESERO', child: Text('MESERO')),
                  DropdownMenuItem(value: 'COCINERO', child: Text('COCINERO')),
                ],
                onChanged: (valor) {
                  setState(() {
                    rolSeleccionado = valor;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardarCambios,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
