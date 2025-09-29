// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import 'feedback_page.dart';
import 'vehicle_management_page.dart';
import 'pet_management_page.dart'; // <-- Importamos la nueva página

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y Unidad'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tarjeta con la información del residente (sin cambios)
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                      radius: 50, child: Icon(Icons.person, size: 60)),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Nombre de Residente',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'correo@ejemplo.com',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildManagementOption(
            context: context,
            icon: Icons.directions_car_filled,
            title: 'Gestionar mis Vehículos',
            subtitle: 'Añade o elimina tus vehículos registrados',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VehicleManagementPage())),
          ),
          const SizedBox(height: 16),

          // --- OPCIÓN DE MASCOTAS ACTUALIZADA ---
          _buildManagementOption(
            context: context,
            icon: Icons.pets,
            title: 'Gestionar mis Mascotas',
            subtitle: 'Añade o elimina tus mascotas registradas',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PetManagementPage())),
          ),
          const SizedBox(height: 16),

          _buildManagementOption(
            context: context,
            icon: Icons.feedback,
            title: 'Reclamos y Sugerencias',
            subtitle: 'Envía un reclamo o sugerencia a la administración',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FeedbackPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
