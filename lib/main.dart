import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Imprimir una variable para asegurarte de que se cargó
  debugPrint(dotenv.env['BASE_URL']);
  
  runApp(const SistemaBancarioApp());
}


class SistemaBancarioApp extends StatelessWidget {
  const SistemaBancarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrestaMovil',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool? isAuthenticated;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Verificar si el usuario está autenticado al iniciar la app
  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Obtén el token guardado

    setState(() {
      isAuthenticated = token != null; // Si hay un token, el usuario está autenticado
    });

    // Depuración
    debugPrint("Token al iniciar: $token");
  }

  @override
  Widget build(BuildContext context) {
    // Si el estado de autenticación aún no ha sido determinado
    if (isAuthenticated == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Si el usuario está autenticado, redirigir al menú principal
    if (isAuthenticated!) {
      return const MenuScreen();
    }

    // Si no está autenticado, redirigir al login
    return const LoginScreen();
  }
}

// Clase para manejar el token
class TokenManager {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    debugPrint("Token guardado: $token");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    debugPrint("Token obtenido desde SharedPreferences: $token");
    return token;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    debugPrint("Token eliminado.");
  }
}
