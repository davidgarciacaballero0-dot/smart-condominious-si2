// lib/pages/wrapper_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import 'login_page.dart';
import 'dashboard_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Este switch revisa el estado de la autenticación
    switch (authProvider.status) {
      // Mientras se verifica si el usuario ya está logueado, muestra un spinner
      case AuthStatus.uninitialized:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      // Si no está autenticado o está en proceso, muestra la página de login
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const LoginPage();

      // Si ya está autenticado, muestra el dashboard
      case AuthStatus.authenticated:
        return const DashboardPage();
    }
  }
}
