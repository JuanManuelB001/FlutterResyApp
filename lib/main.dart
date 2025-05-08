import 'package:flutter/material.dart';
import 'pantallas/registro_screen.dart';
import 'pantallas/login_screen.dart';
import 'pantallas/menu_screen.dart';
import 'pantallas/gestion_usuarios_screen.dart';
import 'pantallas/crear_usuario_screen.dart';
// Pantallas nuevas del módulo de productos
import 'pantallas/inventory_screen.dart';
import 'pantallas/agregar_producto_screen.dart';
import 'pantallas/gestionar_producto_screen.dart';
import 'pantallas/eliminar_producto_screen.dart';

void main() {
  runApp(const ResyApp());
}

class ResyApp extends StatelessWidget {
  const ResyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResyApp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/registro',
      routes: {
        '/registro': (context) => const RegistroScreen(),
        '/login': (context) => const LoginScreen(),
        '/menu': (context) => const MenuScreen(),
        '/gestion': (context) => const GestionUsuariosScreen(),
        '/crear': (context) => const CrearUsuarioScreen(),
        // Rutas nuevas del inventario
        '/inventario': (context) => const InventoryScreen(),
        '/agregar': (context) => const AgregarProductoScreen(),
        '/gestionar': (context) => const GestionarProductoScreen(),
        '/eliminar': (context) => const EliminarProductoScreen(),
      },
    );
  }
}
