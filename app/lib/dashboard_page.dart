import 'package:flutter/material.dart';
import 'package:app/login_page.dart'; // Corregido
import 'package:app/app_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Menú Principal'),
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
      body: const Center(
        child: Text('Bienvenido a Smart Condominium'),
      ),
    );
  }
}
