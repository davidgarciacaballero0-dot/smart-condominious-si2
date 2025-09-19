import 'package:flutter/material.dart';
import 'models/profile_models.dart';

// Importamos todas las páginas que vamos a necesitar para la navegación
import 'dashboard_page.dart';
import 'finances_page.dart';
import 'reservations_page.dart';
import 'communications_page.dart';
import 'vehicle_management_page.dart';
import 'pet_management_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const userProfile = UserProfile(
      name: 'David García',
      unit: 'Uruguay 20',
      email: 'residente@email.com',
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userProfile.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text('${userProfile.unit}\n${userProfile.email}'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 50),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // --- SECCIONES PRINCIPALES ---
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Menú '),
            onTap: () {
              // Cierra el drawer y navega a la página del Dashboard
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Pago de Expensas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FinancesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('Reservas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReservationsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign_outlined),
            title: const Text('Comunicados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunicationsPage()));
            },
          ),

          const Divider(),

          // --- MENÚ DESPLEGABLE PARA "MI UNIDAD" ---
          ExpansionTile(
            leading: const Icon(Icons.home_work_outlined),
            title: const Text(
              'Mi Unidad',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.only(
                    left: 72.0), // Padding aumentado para anidación
                title: const Text('Gestionar Vehículos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VehicleManagementPage()));
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 72.0),
                title: const Text('Gestionar Mascotas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PetManagementPage()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
