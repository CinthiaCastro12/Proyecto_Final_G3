import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PrestamosScreen extends StatefulWidget {
  const PrestamosScreen({super.key});

  @override
  _PrestamosScreenState createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  String? token;
  List<Map<String, dynamic>> clientes = [];

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
      _fetchClientesYPrestamos();
    }
  }

  Future<void> _fetchClientesYPrestamos() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-url.com';
    debugPrint("URL BACKEND: $baseUrl");
    debugPrint("TOKEN ES: $token");

    final clienteResponse = await http.get(
      Uri.parse('$baseUrl/Customer/GetAllCustomer'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final prestamoResponse = await http.get(
      Uri.parse('$baseUrl/Prestamo/GetAllDue'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (clienteResponse.statusCode == 200 && prestamoResponse.statusCode == 200) {
      final List<dynamic> clientesData = json.decode(clienteResponse.body);
      final List<dynamic> prestamosData = json.decode(prestamoResponse.body);

      setState(() {
        clientes = clientesData.map<Map<String, dynamic>>((cliente) {
          final clientePrestamos = prestamosData
              .where((prestamo) => prestamo['clienteId'] == cliente['customerId'])
              .map((prestamo) {
                return {
                  'codigo': 'P${prestamo['prestamoId']}',
                  'monto': '${prestamo['monto']} LPS',
                  'estado': prestamo['estado'] ? 'Pendiente' : 'Pagado',
                  'fecha': prestamo['fechaPrestamo'].split('T')[0],
                };
              }).toList();

          return {
            'id': 'CL${cliente['customerId']}',
            'nombre': '${cliente['nombres']} ${cliente['apellidos']}',
            'saldo': 0.0,
            'prestamos': clientePrestamos,
          };
        }).toList();
      });
    } else {
      debugPrint('Error al cargar los datos: ${clienteResponse.statusCode}, ${prestamoResponse.statusCode}');
    }
  }

  void _agregarCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nombreController = TextEditingController();
        TextEditingController saldoController = TextEditingController();

        return AlertDialog(
          title: const Text('Agregar Nuevo Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre del cliente',
                ),
              ),
              TextField(
                controller: saldoController,
                decoration: const InputDecoration(
                  labelText: 'Saldo',
                  hintText: 'Ingrese el saldo del cliente',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  clientes.add({
                    'id': 'CL${clientes.length + 1}',
                    'nombre': nombreController.text,
                    'saldo': double.tryParse(saldoController.text) ?? 0.0,
                    'prestamos': [],
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Clientes y Préstamos',
    style: TextStyle(color: Colors.white), // Cambiar el color del texto a blanco
  ),
  backgroundColor: Colors.teal,
  centerTitle: true, // Centrar el título
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: _agregarCliente,
               icon: const Icon(Icons.person_add, color: Colors.white), // Cambiar el color del ícono a blanco
              label: const Text(
              'Agregar Cliente',
                style: TextStyle(color: Colors.white), // Cambiar el color del texto a blanco
               ),
                style: ElevatedButton.styleFrom(
              
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, clienteIndex) {
                  final cliente = clientes[clienteIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      leading: const Icon(Icons.person, color: Colors.teal, size: 40),
                      title: Text(cliente['nombre'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${cliente['id']}', style: const TextStyle(fontSize: 14)),
                          Text('Saldo Total: ${cliente['saldo']} LPS', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Resumen de ${cliente['nombre']}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('ID: ${cliente['id']}'),
                                  Text('Saldo Total: ${cliente['saldo']} LPS'),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add),
                                    label: const Text('Agregar Préstamo'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cliente['prestamos'].length,
                                      itemBuilder: (context, prestamoIndex) {
                                        final prestamo = cliente['prestamos'][prestamoIndex];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                            title: Text('Código: ${prestamo['codigo']}'),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Monto: ${prestamo['monto']}'),
                                                Text('Estado: ${prestamo['estado']}'),
                                                Text('Fecha: ${prestamo['fecha']}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
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
