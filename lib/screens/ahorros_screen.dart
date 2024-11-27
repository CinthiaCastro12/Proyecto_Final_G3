import 'package:flutter/material.dart';

// Modelo de cliente
class Cliente {
  String nombre;
  String identificacion;
  double saldoTotal;
  List<CuentaAhorro> cuentas;
  List<Transaccion> transacciones;

  Cliente({
    required this.nombre,
    required this.identificacion,
    required this.saldoTotal,
    required this.cuentas,
    required this.transacciones,
  });
}

class CuentaAhorro {
  final String numeroCuenta;
  final String tipo;
  final double saldo;

  CuentaAhorro({
    required this.numeroCuenta,
    required this.tipo,
    required this.saldo,
  });
}

class Transaccion {
  final String fecha;
  final double monto;
  final String tipo;

  Transaccion({
    required this.fecha,
    required this.monto,
    required this.tipo,
  });
}

class AhorrosScreen extends StatefulWidget {
  const AhorrosScreen({super.key});

  @override
  State<AhorrosScreen> createState() => _AhorrosScreenState();
}

class _AhorrosScreenState extends State<AhorrosScreen> {
  List<Cliente> clientes = []; // Lista vacía de clientes

  // Controladores para los campos del formulario de agregar cliente
  final _nombreController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _saldoTotalController = TextEditingController();

  // Controladores para los campos del formulario de agregar cuentas de ahorro
  final _numeroCuentaController = TextEditingController();
  final _tipoCuentaController = TextEditingController();
  final _saldoCuentaController = TextEditingController();

  // Controladores para los campos del formulario de agregar transacciones
  final _fechaTransaccionController = TextEditingController();
  final _montoTransaccionController = TextEditingController();
  final _tipoTransaccionController = TextEditingController();

  // Función para agregar un nuevo cliente
  void agregarCliente() {
    final nombre = _nombreController.text;
    final identificacion = _identificacionController.text;
    final saldoTotal = double.tryParse(_saldoTotalController.text) ?? 0.0;

    if (nombre.isNotEmpty && identificacion.isNotEmpty && saldoTotal > 0) {
      setState(() {
        clientes.add(Cliente(
          nombre: nombre,
          identificacion: identificacion,
          saldoTotal: saldoTotal,
          cuentas: [],
          transacciones: [],
        ));
      });
      // Limpiar los campos después de agregar el cliente
      _nombreController.clear();
      _identificacionController.clear();
      _saldoTotalController.clear();
      Navigator.pop(context); // Cerrar el formulario
    }
  }

  // Función para agregar una nueva cuenta de ahorro al cliente
  void agregarCuentaAhorro(int clienteIndex) {
    final numeroCuenta = _numeroCuentaController.text;
    final tipoCuenta = _tipoCuentaController.text;
    final saldoCuenta = double.tryParse(_saldoCuentaController.text) ?? 0.0;

    if (numeroCuenta.isNotEmpty && tipoCuenta.isNotEmpty && saldoCuenta > 0) {
      setState(() {
        clientes[clienteIndex].cuentas.add(CuentaAhorro(
          numeroCuenta: numeroCuenta,
          tipo: tipoCuenta,
          saldo: saldoCuenta,
        ));
      });
      // Limpiar los campos después de agregar la cuenta
      _numeroCuentaController.clear();
      _tipoCuentaController.clear();
      _saldoCuentaController.clear();
      Navigator.pop(context); // Cerrar el formulario
    }
  }

  // Función para agregar una nueva transacción al cliente
  void agregarTransaccion(int clienteIndex) {
    final fecha = _fechaTransaccionController.text;
    final monto = double.tryParse(_montoTransaccionController.text) ?? 0.0;
    final tipo = _tipoTransaccionController.text;

    if (fecha.isNotEmpty && monto > 0 && tipo.isNotEmpty) {
      setState(() {
        clientes[clienteIndex].transacciones.add(Transaccion(
          fecha: fecha,
          monto: monto,
          tipo: tipo,
        ));
      });
      // Limpiar los campos después de agregar la transacción
      _fechaTransaccionController.clear();
      _montoTransaccionController.clear();
      _tipoTransaccionController.clear();
      Navigator.pop(context); // Cerrar el formulario
    }
  }

  // Función para abrir el formulario de agregar cliente
  void abrirFormularioCliente() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _identificacionController,
                decoration: const InputDecoration(labelText: 'Identificación'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _saldoTotalController,
                decoration: const InputDecoration(labelText: 'Saldo Total'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el formulario sin agregar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: agregarCliente,
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Función para abrir el formulario de agregar cuenta de ahorro
  void abrirFormularioCuentaAhorro(int clienteIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Cuenta de Ahorro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _numeroCuentaController,
                decoration: const InputDecoration(labelText: 'Número de Cuenta'),
              ),
              TextField(
                controller: _tipoCuentaController,
                decoration: const InputDecoration(labelText: 'Tipo de Cuenta'),
              ),
              TextField(
                controller: _saldoCuentaController,
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el formulario sin agregar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => agregarCuentaAhorro(clienteIndex),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Función para abrir el formulario de agregar transacción
  void abrirFormularioTransaccion(int clienteIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Transacción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fechaTransaccionController,
                decoration: const InputDecoration(labelText: 'Fecha'),
              ),
              TextField(
                controller: _montoTransaccionController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _tipoTransaccionController,
                decoration: const InputDecoration(labelText: 'Tipo (Depósito o Retiro)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el formulario sin agregar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => agregarTransaccion(clienteIndex),
              child: const Text('Guardar'),
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
        backgroundColor: Colors.blueAccent,
        title: const Text('Ahorros', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: clientes.isEmpty
          ? const Center(child: Text('No hay clientes registrados.'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Text(
                      cliente.nombre,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${cliente.identificacion}'),
                    children: [
                      // Resumen del cliente
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Resumen del cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text('Nombre del cliente: ${cliente.nombre}', style: const TextStyle(fontSize: 16)),
                            Text('Identificación: ${cliente.identificacion}', style: const TextStyle(fontSize: 16)),
                            Text('Saldo Total: \$${cliente.saldoTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      // Agregar cuenta de ahorro
                      ListTile(
                        title: const Text('Agregar Cuenta de Ahorro'),
                        leading: const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                        onTap: () => abrirFormularioCuentaAhorro(index),
                      ),
                      // Listar cuentas de ahorro
                      ...cliente.cuentas.map((cuenta) => ListTile(
                            title: Text('Cuenta: ${cuenta.numeroCuenta}'),
                            subtitle: Text('Tipo: ${cuenta.tipo}, Saldo: \$${cuenta.saldo.toStringAsFixed(2)}'),
                          )),
                      // Agregar transacción
                      ListTile(
                        title: const Text('Agregar Transacción'),
                        leading: const Icon(Icons.swap_horiz, color: Colors.blueAccent),
                        onTap: () => abrirFormularioTransaccion(index),
                      ),
                      // Listar transacciones
                      ...cliente.transacciones.map((transaccion) => ListTile(
                            title: Text('${transaccion.tipo}: \$${transaccion.monto.toStringAsFixed(2)}'),
                            subtitle: Text('Fecha: ${transaccion.fecha}'),
                          )),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirFormularioCliente,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AhorrosScreen()));
}
