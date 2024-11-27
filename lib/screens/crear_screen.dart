import 'package:flutter/material.dart';

class CrearSolicitudScreen extends StatefulWidget { // Cambié el nombre de la clase
  const CrearSolicitudScreen({Key? key}) : super(key: key);

  @override
  State<CrearSolicitudScreen> createState() => _CrearSolicitudScreenState();
}

class _CrearSolicitudScreenState extends State<CrearSolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTipo = 'Personal'; // Tipo seleccionado por defecto
  bool _isProcessing = false;

  // Controladores para los campos dinámicos
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  void _enviarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulación del envío de la solicitud
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada con éxito')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Solicitud'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Nueva Solicitud',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTipo,
                items: const [
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Financiera', child: Text('Financiera')),
                  DropdownMenuItem(value: 'Otra', child: Text('Otra')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Tipo de Solicitud',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedTipo = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_selectedTipo == 'Financiera')
                TextFormField(
                  controller: _montoController,
                  decoration: const InputDecoration(
                    labelText: 'Monto Solicitado',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el monto';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la solicitud',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Funcionalidad para adjuntar documentos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función de adjuntar documento en desarrollo')),
                  );
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Adjuntar Documento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 211, 255, 231),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
              const SizedBox(height: 30),
              _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _enviarSolicitud,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text(
                        'Enviar Solicitud',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
