// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'report_incident_page.dart'; // <-- IMPORTAMOS LA NUEVA PÁGINA

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Seguridad'),
        actions: [
          // ... (código del botón de logout sin cambios)
        ],
      ),
      drawer: const SecurityDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: <Widget>[
          DashboardCard(
            icon: Icons.person_add_alt_1_outlined,
            title: 'Registrar Visita',
            onTap: () {
              // TODO: Navegar a la página de registro de visitas
            },
          ),
          DashboardCard(
            icon: Icons.report_problem_outlined,
            title: 'Reportar Incidente',
            onTap: () {
              // --- NAVEGACIÓN AÑADIDA AQUÍ ---
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportIncidentPage()),
              );
            },
          ),
          // ... (resto de las tarjetas)
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0),
            const SizedBox(height: 8.0),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class SecurityDrawer extends StatelessWidget {
  const SecurityDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu de Seguridad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
