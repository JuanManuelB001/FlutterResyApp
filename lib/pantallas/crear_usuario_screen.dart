import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _usuarioNombreController = TextEditingController();
  String? _rolController;
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nombreController.dispose();
    _apellidoController.dispose();
    _cedulaController.dispose();
    _usuarioNombreController.dispose();

    _contrasenaController.dispose();
    super.dispose();
  }

  void _registrarUsuario() async {
    final nombre = _nombreController.text;
    final apellido = _nombreController.text;
    final cedula = _nombreController.text;
    final usuario = _usuarioNombreController.text;
    final rol = _rolController;
    final contrasena = _contrasenaController.text;

    // ENDPOINT
    //http://localhost:8863/rest/
    final urlEndPoint = Uri.parse('https://resyapp-m4ap.onrender.com/rest/');
    //DICCIONARIO CREAR UN USUARIO
    final Map<String, dynamic> usuarioRest = {
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'nombreUsuario': rol,
      'contrasena': contrasena,
      'rol': rol,
    };
    // ENVIAR LA SOLICITUD
    try {
      final response = await http.post(
        urlEndPoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuarioRest),
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

    print('Nombre: $nombre');
    print('Usuario: $usuario');
    print('Rol: $rol');
    print('Contraseña: $contrasena');

    // Puedes redirigir si lo deseas
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Primer Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'apellido'),
            ),
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(labelText: 'Cedula'),
            ),
            TextField(
              controller: _usuarioNombreController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            DropdownButtonFormField<String>(
              value: _rolController,
              items:
                  ['MESERO', 'ADMIN'].map((String rol) {
                    return DropdownMenuItem<String>(
                      value: rol,
                      child: Text(rol),
                    );
                  }).toList(),
              onChanged: (String? nuevoValor) {
                setState(() {
                  _rolController = nuevoValor;
                });
              },
              decoration: const InputDecoration(labelText: 'Rol'),
            ),

            TextField(
              controller: _contrasenaController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
