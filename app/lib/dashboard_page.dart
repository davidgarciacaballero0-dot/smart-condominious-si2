import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Principal'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2, // Muestra 2 columnas
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: const <Widget>[
          // Tarjeta para la sección de Finanzas
          DashboardCard(
            icon: Icons.monetization_on,
            title: 'Finanzas',
          ),
          // Tarjeta para la sección de Comunicados
          DashboardCard(
            icon: Icons.campaign,
            title: 'Comunicados',
          ),
          // Tarjeta para la sección de Reservas
          DashboardCard(
            icon: Icons.event,
            title: 'Reservas',
          ),
          // Tarjeta para la sección de Notificaciones
          DashboardCard(
            icon: Icons.notifications,
            title: 'Notificaciones',
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable para las tarjetas del Dashboard
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          // Acción al tocar la tarjeta (por ahora solo muestra un mensaje)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navegando a $title...')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Colors.blueGrey[700]),
            const SizedBox(height: 16.0),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
