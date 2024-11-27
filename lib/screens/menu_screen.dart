import 'package:flutter/material.dart';
import 'prestamos_screen.dart';
import 'ahorros_screen.dart';
import 'solicitudes_screen.dart';
import 'simulacion_screen.dart';
import 'login_screen.dart'; // Asegúrate de importar tu pantalla de login existente

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        backgroundColor: Colors.teal, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Regresar al login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            MenuCard(
              icon: Icons.account_balance,
              title: 'Préstamos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrestamosScreen()),
                );
              },
            ),
            MenuCard(
              icon: Icons.savings,
              title: 'Ahorros',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AhorrosScreen()),
                );
              },
            ),
            
            MenuCard(
              icon: Icons.assignment,
              title: 'Solicitudes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SolicitudesScreen()),
                );
              },
            ),
            MenuCard(
              icon: Icons.calculate,
              title: 'Simular Préstamo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimulacionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.teal,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
