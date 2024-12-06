import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  _SolicitudesScreenState createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  List<Map<String, dynamic>> clientes = [];
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Cargar el token desde SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('accessToken');
    setState(() {
      token = storedToken;
    });
    if (token != null) {
      _fetchClientesYSolicitudes();
    }
  }

  // Obtener clientes y solicitudes
  Future<void> _fetchClientesYSolicitudes() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-url.com';
    debugPrint("URL BACKEND: $baseUrl");
    debugPrint("TOKEN ES: $token");

    // Obtener los clientes
    final clienteResponse = await http.get(
      Uri.parse('$baseUrl/Customer/GetAllCustomer'),
      headers: {
        'Authorization': 'Bearer $token', // Añadir el token al encabezado
      },
    );

    // Obtener las solicitudes
    final solicitudResponse = await http.get(
      Uri.parse('$baseUrl/Solicitud/GetAllSolit'),
      headers: {
        'Authorization': 'Bearer $token', // Añadir el token al encabezado
      },
    );

    if (clienteResponse.statusCode == 200 && solicitudResponse.statusCode == 200) {
      final List<dynamic> clientesData = json.decode(clienteResponse.body);
      final List<dynamic> solicitudesData = json.decode(solicitudResponse.body);

      setState(() {
        // Crear la lista de clientes con las solicitudes asociadas
        clientes = clientesData.map<Map<String, dynamic>>((cliente) {
          final clienteSolicitudes = solicitudesData
              .where((solicitud) => solicitud['customerId'] == cliente['customerId'])
              .map((solicitud) {
                return {
                  'solicitudId': solicitud['solicitudId'],
                  'proposito': solicitud['proposito'],
                  'monto': solicitud['monto'],
                  'tasaInteres': solicitud['tasaInteres'],
                  'plazo': solicitud['plazo'],
                  'estado': solicitud['estado'] ? 'Activo' : 'Inactivo',
                  'fechaCreacion': solicitud['fechaCreacion'],
                };
              }).toList();

          return {
            'id': cliente['customerId'],
            'nombre': '${cliente['nombres']} ${cliente['apellidos']}',
            'solicitudes': clienteSolicitudes,
          };
        }).toList();
      });
    } else {
      debugPrint('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes'),
        backgroundColor: Colors.teal,
      ),
      body: clientes.isEmpty
          ? const Center(child: Text('No hay clientes registrados.'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, clienteIndex) {
                final cliente = clientes[clienteIndex];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(cliente['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Solicitudes: ${cliente['solicitudes'].length} registradas'),
                      ],
                    ),
                    onTap: () {
                      // Mostrar el modal con las solicitudes del cliente
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // Permite que el modal se ajuste al contenido
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Resumen de ${cliente['nombre']}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('ID: ${cliente['id']}'),
                                  Text('Solicitudes: ${cliente['solicitudes'].length}'),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Detalles de las Solicitudes',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true, // Evita que ocupe más espacio del necesario
                                      itemCount: cliente['solicitudes'].length,
                                      itemBuilder: (context, solicitudIndex) {
                                        final solicitud = cliente['solicitudes'][solicitudIndex];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListTile(
                                            title: Text('Propósito: ${solicitud['proposito']}'),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Monto: ${solicitud['monto']}'),
                                                Text('Tasa de Interés: ${solicitud['tasaInteres']}'),
                                                Text('Plazo: ${solicitud['plazo']}'),
                                                Text('Estado: ${solicitud['estado']}'),
                                                Text('Fecha de Creación: ${solicitud['fechaCreacion']}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
