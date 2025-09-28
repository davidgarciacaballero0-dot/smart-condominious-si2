// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/app_drawer.dart';

// Importamos SOLAMENTE las páginas que SÍ existen
import 'reservations_page.dart';
import 'communications_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userRole = user?.roleName ?? 'Unknown';

    // Función de ayuda para navegar
    void navigateToPage(Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }

    // --- Menú para el Residente ---
    List<Widget> residentMenu = [
      DashboardCard(
        icon: Icons.monetization_on,
        title: 'Finanzas',
        onTap: () {
          // ACCIÓN TEMPORAL para no generar errores
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Módulo de Finanzas en construcción.'),
            duration: Duration(seconds: 2),
          ));
        },
      ),
      DashboardCard(
        icon: Icons.event,
        title: 'Reservas',
        onTap: () => navigateToPage(const ReservationsPage()),
      ),
      DashboardCard(
        icon: Icons.chat,
        title: 'Comunicados',
        onTap: () => navigateToPage(const CommunicationsPage()),
      ),
      DashboardCard(
        icon: Icons.person,
        title: 'Mi Perfil',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Módulo de Perfil en construcción.'),
            duration: Duration(seconds: 2),
          ));
        },
      ),
    ];

    // --- Menú para el Personal ---
    List<Widget> staffMenu = [
      DashboardCard(
        icon: Icons.people,
        title: 'Registro de Visitantes',
        onTap: () {},
      ),
      DashboardCard(
        icon: Icons.build,
        title: 'Tareas de Mantenimiento',
        onTap: () {},
      ),
      DashboardCard(
        icon: Icons.security,
        title: 'Incidentes de Seguridad',
        onTap: () {},
      ),
    ];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Image.asset('assets/images/logo_main.png', height: 40),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido,',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              user?.fullName ?? 'Usuario',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: userRole == 'Residente' ? residentMenu : staffMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
