// app/lib/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:app/app_drawer.dart';
import 'package:app/communications_page.dart';
import 'package:app/finances_page.dart';
import 'package:app/reservations_page.dart';
import 'package:app/vehicle_management_page.dart';
import 'package:app/pet_management_page.dart';
import 'package:app/maintenance_dashboard_page.dart';
import 'package:app/security_dashboard_page.dart';

class DashboardPage extends StatelessWidget {
  // El rol ahora se pasará desde la página de login
  final String role;
  const DashboardPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Condominium'),
      ),
      drawer: AppDrawer(role: role),
      body: _buildDashboardForRole(context, role),
    );
  }

  Widget _buildDashboardForRole(BuildContext context, String userRole) {
    switch (userRole.toLowerCase()) {
      case 'residente':
        return _buildResidentDashboard(context);
      case 'mantenimiento':
        return const MaintenanceDashboardPage(); // Reutilizamos la página de lista de tareas
      case 'seguridad':
        return const SecurityDashboardPage(); // Reutilizamos el panel de seguridad
      default:
        return const Center(child: Text('Rol no reconocido.'));
    }
  }

  Widget _buildResidentDashboard(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        _buildDashboardCard(
          context,
          icon: Icons.notifications,
          label: 'Comunicados',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CommunicationsPage())),
        ),
        _buildDashboardCard(
          context,
          icon: Icons.monetization_on,
          label: 'Mis Finanzas',
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const FinancesPage())),
        ),
        _buildDashboardCard(
          context,
          icon: Icons.event,
          label: 'Reservas',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReservationsPage())),
        ),
        _buildDashboardCard(
          context,
          icon: Icons.directions_car,
          label: 'Mis Vehículos',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const VehicleManagementPage())),
        ),
        _buildDashboardCard(
          context,
          icon: Icons.pets,
          label: 'Mis Mascotas',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PetManagementPage())),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16.0),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
