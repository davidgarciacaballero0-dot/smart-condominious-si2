// app/lib/dashboard_page.dart

// ignore_for_file: deprecated_member_use

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

// Reemplaza el método _buildDashboardCard existente con este:
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
              16), // Para que el efecto de pulsación tenga bordes redondeados
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48.0, color: Colors.white),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, // Ajuste de tamaño para mejor legibilidad
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
