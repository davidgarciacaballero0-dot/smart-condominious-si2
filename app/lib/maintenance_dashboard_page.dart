// Archivo: lib/maintenance_dashboard_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart'; // Importamos la página de login

class MaintenanceDashboardPage extends StatelessWidget {
  const MaintenanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Mantenimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) =>
                    false, // Elimina todas las rutas anteriores
              );
            },
          ),
        ],
      ),
      body:
          const Center(child: Text('Vista para el Personal de Mantenimiento')),
    );
  }
}
