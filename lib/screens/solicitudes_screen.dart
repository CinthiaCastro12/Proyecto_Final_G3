import 'package:flutter/material.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({Key? key}) : super(key: key);

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  final List<Map<String, dynamic>> clientes = [];

  void _agregarCliente() async {
    final nuevoCliente = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearClienteScreen(clientes: clientes),
      ),
    );

    if (nuevoCliente != null) {
      setState(() {
        clientes.add(nuevoCliente);
      });
    }
  }

  void _modificarCliente(Map<String, dynamic> cliente) async {
    final clienteActualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearClienteScreen(clientes: clientes, cliente: cliente),
      ),
    );

    if (clienteActualizado != null) {
      setState(() {
        final index = clientes.indexOf(cliente);
        clientes[index] = clienteActualizado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes y Solicitudes'),
        backgroundColor: Colors.teal,
      ),
      body: clientes.isEmpty
          ? const Center(child: Text('No hay clientes registrados.'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${cliente['nombre']} ${cliente['apellido']}'),
                    subtitle: Text('Solicitudes: ${cliente['solicitudes'].length} registradas'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _modificarCliente(cliente),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleClienteScreen(cliente: cliente),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCliente,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class CrearClienteScreen extends StatefulWidget {
  final Map<String, dynamic>? cliente;
  final List<Map<String, dynamic>> clientes;

  const CrearClienteScreen({Key? key, this.cliente, required this.clientes})
      : super(key: key);

  @override
  State<CrearClienteScreen> createState() => _CrearClienteScreenState();
}

class _CrearClienteScreenState extends State<CrearClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  String _tipoSolicitud = 'Personal';
  final List<Map<String, dynamic>> _solicitudes = [];
  bool _mostrarFinanciera = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _idController.text = widget.cliente!['id'].toString();
      _nombreController.text = widget.cliente!['nombre'];
      _apellidoController.text = widget.cliente!['apellido'];
      _solicitudes.addAll(widget.cliente!['solicitudes']);
    }
  }

  void _agregarSolicitud() {
    final nuevaSolicitud = {
      'estado': 'Pendiente',
      'tipo': _tipoSolicitud,
      'fecha': DateTime.now().toString(),
      'motivo': _motivoController.text,
      'monto': _tipoSolicitud == 'Financiera' ? _montoController.text : null,
    };

    setState(() {
      _solicitudes.add(nuevaSolicitud);
      _motivoController.clear();
      _montoController.clear();
      _mostrarFinanciera = false;
    });
  }

  void _guardarCliente() {
    if (_formKey.currentState!.validate()) {
      final cliente = {
        'id': int.parse(_idController.text),
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'solicitudes': _solicitudes,
      };

      Navigator.pop(context, cliente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear/Editar Cliente'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID del Cliente',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el ID del cliente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Cliente',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el nombre del cliente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido del Cliente',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el apellido del cliente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _tipoSolicitud,
                  onChanged: (newValue) {
                    setState(() {
                      _tipoSolicitud = newValue!;
                      _mostrarFinanciera = _tipoSolicitud == 'Financiera';
                    });
                  },
                  items: ['Personal', 'Financiera', 'Otra']
                      .map((tipo) => DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(tipo),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Solicitud',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_mostrarFinanciera) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _montoController,
                    decoration: const InputDecoration(
                      labelText: 'Monto Solicitado',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: _motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de la Solicitud',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _agregarSolicitud,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Solicitud'),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _solicitudes.length,
                  itemBuilder: (context, index) {
                    final solicitud = _solicitudes[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(solicitud['tipo']),
                        subtitle: Text(
                          'Estado: ${solicitud['estado']}\nMotivo: ${solicitud['motivo']}\n'
                          '${solicitud['monto'] != null ? 'Monto: ${solicitud['monto']}' : ''}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              solicitud['estado'] = value;
                            });
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: 'Aprobada',
                              child: Text('Aprobar'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Rechazada',
                              child: Text('Rechazar'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Pendiente',
                              child: Text('Pendiente'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guardarCliente,
        child: const Icon(Icons.save),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class DetalleClienteScreen extends StatelessWidget {
  final Map<String, dynamic> cliente;

  const DetalleClienteScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${cliente['nombre']} ${cliente['apellido']}'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: cliente['solicitudes'].length,
        itemBuilder: (context, index) {
          final solicitud = cliente['solicitudes'][index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Solicitud ${index + 1}: ${solicitud['tipo']}'),
              subtitle: Text(
                'Estado: ${solicitud['estado']}\nMotivo: ${solicitud['motivo']}\n'
                '${solicitud['monto'] != null ? 'Monto: ${solicitud['monto']}' : ''}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  solicitud['estado'] = value;
                  (context as Element).markNeedsBuild(); // Actualizar pantalla
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'Aprobada',
                    child: Text('Aprobar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Rechazada',
                    child: Text('Rechazar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Pendiente',
                    child: Text('Pendiente'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
