import 'package:flutter/material.dart';
import 'package:app/login_page.dart';
import 'package:app/report_incident_page.dart';
import 'package:app/visitor_log_page.dart';
import 'package:app/dashboard_card.dart'; // <-- IMPORTANTE: Añadimos la importación

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Seguridad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
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
            // <-- Esto ahora funcionará
            icon: Icons.person_add_alt_1_outlined,
            title: 'Registrar Visita',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorLogPage()),
              );
            },
          ),
          DashboardCard(
            // <-- Esto ahora funcionará
            icon: Icons.report_problem_outlined,
            title: 'Reportar Incidente',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportIncidentPage()),
              );
            },
          ),
          DashboardCard(
            // <-- Esto ahora funcionará
            icon: Icons.notifications_active_outlined,
            title: 'Alertas IA',
            onTap: () {},
          ),
          DashboardCard(
            // <-- Esto ahora funcionará
            icon: Icons.camera_outdoor_outlined,
            title: 'Ver Cámaras',
            onTap: () {},
          ),
        ],
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
          UserAccountsDrawerHeader(
            accountName: const Text('Carlos Rojas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text('Personal de Seguridad'),
            currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.security_outlined, size: 50)),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.view_list_outlined),
            title: const Text('Historial de Visitas'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('Historial de Incidentes'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
