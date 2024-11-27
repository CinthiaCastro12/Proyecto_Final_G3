import 'package:flutter/material.dart';

class PrestamosScreen extends StatefulWidget {
  const PrestamosScreen({super.key});

  @override
  _PrestamosScreenState createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  // Lista de clientes, cada cliente tiene su propio resumen y préstamos
  List<Map<String, dynamic>> clientes = [
    {
      'id': 'CL001',
      'nombre': 'Juan Pérez',
      'saldo': 8000,
      'prestamos': [
        {
          'codigo': 'P001',
          'monto': '5000 LPS',
          'estado': 'Pendiente',
          'fecha': '2024-01-10',
        },
        {
          'codigo': 'P002',
          'monto': '3000 LPS',
          'estado': 'Pagado',
          'fecha': '2023-08-15',
        },
      ],
    },
  ];

  void _agregarCliente() {
    // Función para agregar un nuevo cliente
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
                  // Agregar el nuevo cliente a la lista
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

  void _agregarPrestamo(int clienteIndex) {
    // Función para agregar un préstamo a un cliente específico
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController montoController = TextEditingController();
        TextEditingController fechaController = TextEditingController();

        return AlertDialog(
          title: const Text('Solicitar Nuevo Préstamo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: montoController,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  hintText: 'Ingrese el monto solicitado',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'Ingrese la fecha (YYYY-MM-DD)',
                ),
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
                  // Agregar un nuevo préstamo al cliente
                  clientes[clienteIndex]['prestamos'].add({
                    'codigo': 'P${clientes[clienteIndex]['prestamos'].length + 1}',
                    'monto': '${montoController.text} LPS',
                    'estado': 'Pendiente',
                    'fecha': fechaController.text,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Solicitar'),
            ),
          ],
        );
      },
    );
  }

  void _modificarEstadoPrestamo(int clienteIndex, int prestamoIndex) {
    // Función para cambiar el estado del préstamo
    String estadoActual = clientes[clienteIndex]['prestamos'][prestamoIndex]['estado'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nuevoEstado = estadoActual;

        return AlertDialog(
          title: const Text('Modificar Estado del Préstamo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: nuevoEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    nuevoEstado = newValue!;
                  });
                },
                items: <String>['Pendiente', 'Pagado', 'Cancelado']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                  // Actualizar el estado del préstamo con el nuevo valor
                  clientes[clienteIndex]['prestamos'][prestamoIndex]['estado'] = nuevoEstado;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Modificar'),
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
        title: const Text('Clientes y Préstamos'),
        backgroundColor:Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón para agregar un nuevo cliente
            Center(
              child: ElevatedButton.icon(
                onPressed: _agregarCliente,
                icon: const Icon(Icons.person_add),
                label: const Text('Agregar Cliente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de clientes
            Expanded(
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, clienteIndex) {
                  final cliente = clientes[clienteIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.teal),
                      title: Text(cliente['nombre']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${cliente['id']}'),
                          Text('Saldo Total: ${cliente['saldo']} LPS'),
                        ],
                      ),
                      onTap: () {
                        // Mostrar los préstamos del cliente
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Resumen de ${cliente['nombre']}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('ID: ${cliente['id']}'),
                                  Text('Saldo Total: ${cliente['saldo']} LPS'),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () => _agregarPrestamo(clienteIndex),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Agregar Préstamo'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.teal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Mostrar los préstamos del cliente
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cliente['prestamos'].length,
                                      itemBuilder: (context, prestamoIndex) {
                                        final prestamo = cliente['prestamos'][prestamoIndex];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          elevation: 2,
                                          child: ListTile(
                                            title: Text('Código: ${prestamo['codigo']}'),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Monto: ${prestamo['monto']}'),
                                                Text('Estado: ${prestamo['estado']}'),
                                                Text('Fecha: ${prestamo['fecha']}'),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _modificarEstadoPrestamo(clienteIndex, prestamoIndex),
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
