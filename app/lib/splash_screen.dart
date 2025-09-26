// app/lib/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/login_page.dart';
import 'package:app/dashboard_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Damos un pequeño respiro para que se vea la pantalla de carga
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Intentamos obtener el perfil del usuario.
      // Esto valida el token y nos da el rol.
      final userProfile = await _authService.getUserProfile();
      if (mounted) {
        // Si tenemos éxito, vamos al Dashboard con el rol correcto
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => DashboardPage(role: userProfile.role)),
        );
      }
    } catch (e) {
      // Si hay cualquier error (no hay token, token expirado, etc.),
      // vamos a la página de login.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Una pantalla de carga simple con el logo
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_main.png', width: 150),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
