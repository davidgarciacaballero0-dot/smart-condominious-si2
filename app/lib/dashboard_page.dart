// ignore_for_file: unused_import, duplicate_ignore

import 'package:flutter/material.dart';

// ignore: unused_import
import 'package.flutter/material.dart';
// Importa las páginas que creamos
import 'finances_page.dart';
// ignore: unused_import
import 'reservations_page.dart';
import 'communications_page.dart';
import 'login_page.dart'; // <-- 1. IMPORTA LA PÁGINA DE LOGIN

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Principal'),
        automaticallyImplyLeading: false,
        // --- 2. AÑADIMOS LA SECCIÓN DE ACCIONES AQUÍ ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión', // Mensaje que aparece al dejar presionado
            onPressed: () {
              // Lógica para cerrar sesión y volver a la pantalla de login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) =>
                    false, // Elimina todas las rutas anteriores
              );
            },
          ),
        ],
        // -----------------------------------------
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: <Widget>[
          DashboardCard(
            icon: Icons.monetization_on,
            title: 'Finanzas',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FinancesPage()));
            },
          ),
          DashboardCard(
            icon: Icons.campaign,
            title: 'Comunicados',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunicationsPage()));
            },
          ),
          DashboardCard(
            icon: Icons.event,
            title: 'Reservas',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReservationsPage()));
            },
          ),
          DashboardCard(
            icon: Icons.notifications,
            title: 'Notificaciones',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Sección de Notificaciones en construcción.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finanzas')),
      body: const Center(child: Text('Página de Finanzas')),
    );
  }
}

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservas')),
      body: const Center(child: Text('Página de Reservas')),
    );
  }
}

class CommunicationsPage extends StatelessWidget {
  const CommunicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comunicados')),
      body: const Center(child: Text('Página de Comunicados')),
    );
  }
}

// Widget reutilizable para las tarjetas del Dashboard (Este no cambia)
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: colorScheme.primary),
            const SizedBox(height: 16.0),
            Text(title, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
