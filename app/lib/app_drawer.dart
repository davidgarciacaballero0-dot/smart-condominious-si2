import 'package:flutter/material.dart';
import 'models/profile_models.dart';

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
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              // Si el usuario ya está en el dashboard, solo cierra el drawer.
              // Si estuviera en otra página, aquí podríamos navegar al dashboard.
              Navigator.pop(context);
            },
          ),
          const Divider(),

          // --- MENÚ DESPLEGABLE PARA "MI UNIDAD" ---
          ExpansionTile(
            leading: const Icon(Icons.home_work_outlined),
            title: const Text(
              'Mi Unidad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              // Opción para gestionar vehículos (dentro del menú)
              ListTile(
                contentPadding:
                    const EdgeInsets.only(left: 32.0), // Aumentamos el padding
                leading: const Icon(Icons.directions_car_outlined),
                title: const Text('Gestionar Vehículos'),
                onTap: () {
                  // TODO: Navegar a la página de gestión de vehículos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a Vehículos...')),
                  );
                },
              ),
              // Opción para gestionar mascotas (dentro del menú)
              ListTile(
                contentPadding:
                    const EdgeInsets.only(left: 32.0), // Aumentamos el padding
                leading: const Icon(Icons.pets_outlined),
                title: const Text('Gestionar Mascotas'),
                onTap: () {
                  // TODO: Navegar a la página de gestión de mascotas
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a Mascotas...')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
