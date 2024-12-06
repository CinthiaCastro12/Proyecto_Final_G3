import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CuentasScreen extends StatefulWidget {
  const CuentasScreen({super.key});

  @override
  _CuentasScreenState createState() => _CuentasScreenState();
}

class _CuentasScreenState extends State<CuentasScreen> {
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
      _fetchClientesYCuentas();
    }
  }

  Future<void> _fetchClientesYCuentas() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-url.com';
    debugPrint("URL BACKEND: $baseUrl");
    debugPrint("TOKEN ES: $token");

    // Obtener los clientes
    final clienteResponse = await http.get(
      Uri.parse('$baseUrl/Customer/GetAllCustomer'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Obtener las cuentas
    final cuentaResponse = await http.get(
      Uri.parse('$baseUrl/Cuenta/GetAllAccounts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (clienteResponse.statusCode == 200 && cuentaResponse.statusCode == 200) {
      final List<dynamic> clientesData = json.decode(clienteResponse.body);
      final List<dynamic> cuentasData = json.decode(cuentaResponse.body);

      // Verificar si el widget está montado antes de llamar a setState
      if (mounted) {
        setState(() {
          // Crear la lista de clientes con las cuentas asociadas
          clientes = clientesData.map<Map<String, dynamic>>((cliente) {
            // Buscar cuentas asociadas al cliente
            final clienteCuentas = cuentasData
                .where((cuenta) => cuenta['customerId'] == cliente['customerId'])
                .map((cuenta) {
                  return {
                    'cuentaId': cuenta['cuentaId'],
                    'saldo': cuenta['saldo'],
                  };
                }).toList();

            // Devolver el cliente con sus cuentas y saldo
            return {
              'id': 'CL${cliente['customerId']}',
              'nombre': '${cliente['nombres']} ${cliente['apellidos']}',
              'saldo': clienteCuentas.isNotEmpty ? clienteCuentas[0]['saldo'] : 0.0, // Mostrar saldo de la primera cuenta
              'cuentas': clienteCuentas,
            };
          }).toList();
        });
      }
    } else {
      debugPrint('Error al cargar los datos: ${clienteResponse.statusCode}, ${cuentaResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuentas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true, // Centra el título en la AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de clientes
            Expanded(
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, clienteIndex) {
                  final cliente = clientes[clienteIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4, // Añadido para un efecto más elegante
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_wallet, color: Colors.teal), // Cambio el ícono
                      title: Text(
                        cliente['nombre'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo Actual: ${cliente['saldo']} LPS',
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Aquí puedes hacer algo si necesitas al hacer click, actualmente solo muestra el cliente y saldo
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
