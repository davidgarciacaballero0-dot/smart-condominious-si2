// lib/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/login_page.dart';
import 'package:app/profile_page.dart'; // <-- AÑADE ESTA IMPORTACIÓN

class AppDrawer extends StatelessWidget {
  final String role;
  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Smart Condominium'),
            accountEmail: Text('Bienvenido'),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Opción común para todos los roles
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Mi Perfil'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()));
                  },
                ),
                const Divider(),
                // Aquí puedes volver a añadir las opciones específicas por rol si quieres
                if (role == 'residente') ...[
                  // ... tus ListTile para residentes
                ],
                if (role == 'seguridad') ...[
                  // ... tus ListTile para seguridad
                ],
                // ... etc
              ],
            ),
          ),
          // Botón de Cerrar Sesión siempre al final
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) =>
                      false, // Elimina todas las rutas anteriores
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
