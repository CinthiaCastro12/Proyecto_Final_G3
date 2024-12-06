import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  String? token;
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('accessToken');
    setState(() {
      token = storedToken;
    });
    if (token != null) {
      _fetchUsuarios();
    }
  }

  Future<void> _fetchUsuarios() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-url.com';
    debugPrint("URL BACKEND: $baseUrl");
    debugPrint("TOKEN ES: $token");

    // Obtener los usuarios
    final usuarioResponse = await http.get(
      Uri.parse('$baseUrl/GetAll'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (usuarioResponse.statusCode == 200) {
      final List<dynamic> usuariosData = json.decode(usuarioResponse.body);

      setState(() {
        usuarios = usuariosData.map<Map<String, dynamic>>((usuario) {
          return {
            'id': usuario['usuarioId'],
            'nombre': '${usuario['nombres']} ${usuario['apellidos']}',
            'correo': usuario['correo'],
            'celular': usuario['celular'],
            'estado': usuario['estado'] ? 'Activo' : 'Inactivo',
          };
        }).toList();
      });
    } else {
      debugPrint('Error al cargar los datos: ${usuarioResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de usuarios
            Expanded(
              child: ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, usuarioIndex) {
                  final usuario = usuarios[usuarioIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.teal),
                      title: Text(usuario['nombre']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Correo: ${usuario['correo']}'),
                          Text('Celular: ${usuario['celular']}'),
                          Text('Estado: ${usuario['estado']}'),
                        ],
                      ),
                      onTap: () {
                        // Aquí puedes hacer algo si necesitas al hacer click
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
