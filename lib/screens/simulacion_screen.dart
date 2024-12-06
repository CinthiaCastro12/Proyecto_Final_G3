import 'package:flutter/material.dart';

class SimulacionScreen extends StatefulWidget {
  const SimulacionScreen({super.key});

  @override
  _SimulacionScreenState createState() => _SimulacionScreenState();
}

class _SimulacionScreenState extends State<SimulacionScreen> {
  final TextEditingController montoController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController aporteController = TextEditingController();

  double cuota = 0.0;
  double saldoProyectado = 0.0;
  int selectedTabIndex = 0;

  void calcularCuota() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double tasaInteres = double.tryParse(tasaController.text) ?? 0.05;
    int plazo = int.tryParse(plazoController.text) ?? 12;

    setState(() {
      cuota = (monto * (1 + tasaInteres)) / plazo;
    });
  }

  void calcularAhorro() {
    double montoInicial = double.tryParse(montoController.text) ?? 0.0;
    double aporteMensual = double.tryParse(aporteController.text) ?? 0.0;
    double tasaInteresAnual = double.tryParse(tasaController.text) ?? 0.05;
    int plazo = int.tryParse(plazoController.text) ?? 12;

    setState(() {
      saldoProyectado = montoInicial;

      double tasaInteresMensual = tasaInteresAnual / 12;

      for (int i = 0; i < plazo; i++) {
        saldoProyectado += aporteMensual;
        saldoProyectado *= (1 + tasaInteresMensual);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
      title: const Text(
        'Simulación Financiera',
        style: TextStyle(
          color:Colors.teal, // Cambia el color del texto aquí
          fontSize: 24
        )
      ) ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs para seleccionar la simulación
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: "Simulación Préstamo"),
                      Tab(text: "Simulación Ahorro"),
                    ],
                    indicatorColor: Colors.white,  // Cambié el color del indicador de la pestaña
                  ),
                  SizedBox(
                    height: 500, // Tamaño ajustado del contenido
                    child: const TabBarView(
                      children: [
                        _SimulacionPrestamo(),
                        _SimulacionAhorro(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimulacionPrestamo extends StatefulWidget {
  const _SimulacionPrestamo({super.key});

  @override
  _SimulacionPrestamoState createState() => _SimulacionPrestamoState();
}

class _SimulacionPrestamoState extends State<_SimulacionPrestamo> {
  final TextEditingController montoController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();

  double cuota = 0.0;

  void calcularCuota() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double tasaInteres = double.tryParse(tasaController.text) ?? 0.05;
    int plazo = int.tryParse(plazoController.text) ?? 12;

    setState(() {
      cuota = (monto * (1 + tasaInteres)) / plazo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: const Color.fromARGB(255, 251, 255, 251), // Color tea aplicado al fondo de la tarjeta
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simulación Préstamo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: montoController,
                    decoration: const InputDecoration(labelText: 'Monto del Préstamo'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: tasaController,
                    decoration: const InputDecoration(labelText: 'Tasa de Interés'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: plazoController,
                    decoration: const InputDecoration(labelText: 'Plazo en meses'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: calcularCuota,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 177, 159)),
                    child: const Text('Calcular Cuota'),
                  ),
                  const SizedBox(height: 20),
                  Text('Cuota Mensual: \$${cuota.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulacionAhorro extends StatefulWidget {
  const _SimulacionAhorro({super.key});

  @override
  _SimulacionAhorroState createState() => _SimulacionAhorroState();
}

class _SimulacionAhorroState extends State<_SimulacionAhorro> {
  final TextEditingController montoController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController aporteController = TextEditingController();

  double saldoProyectado = 0.0;

  void calcularAhorro() {
    double montoInicial = double.tryParse(montoController.text) ?? 0.0;
    double aporteMensual = double.tryParse(aporteController.text) ?? 0.0;
    double tasaInteresAnual = double.tryParse(tasaController.text) ?? 0.05;
    int plazo = int.tryParse(plazoController.text) ?? 12;

    setState(() {
      saldoProyectado = montoInicial;

      double tasaInteresMensual = tasaInteresAnual / 12;

      for (int i = 0; i < plazo; i++) {
        saldoProyectado += aporteMensual;
        saldoProyectado *= (1 + tasaInteresMensual);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: const Color.fromARGB(255, 255, 255, 255), // Color tea aplicado al fondo de la tarjeta
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulación Ahorro',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: montoController,
                      decoration: const InputDecoration(labelText: 'Monto Inicial'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: tasaController,
                      decoration: const InputDecoration(labelText: 'Tasa de Interés Anual'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: plazoController,
                      decoration: const InputDecoration(labelText: 'Plazo en meses'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: aporteController,
                      decoration: const InputDecoration(labelText: 'Aporte Mensual'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: calcularAhorro,
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text('Calcular Ahorro'),
                    ),
                    const SizedBox(height: 20),
                    Text('Saldo Proyectado: \$${saldoProyectado.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
