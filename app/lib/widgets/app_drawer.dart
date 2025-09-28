// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

// --- IMPORTACIONES CORREGIDAS Y COMPLETAS ---
import '../pages/dashboard_page.dart';
import '../pages/reservations_page.dart'; // <-- IMPORTACIÓN QUE FALTABA
import '../pages/communications_page.dart';
import '../pages/finances_page.dart';
import '../pages/profile_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.fullName ?? 'Nombre de Usuario',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? 'email@dominio.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Menú Principal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
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
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Mi Perfil y Unidad'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}
// --- FIN DEL CÓDIGO CORREGIDO Y COMPLETO ---
