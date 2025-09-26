// app/lib/login_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _performLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      // Intenta iniciar sesión con el servicio de autenticación
      await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      // --- ESTA ES LA LÓGICA CORREGIDA ---
      // Deducimos el rol basado en el correo electrónico para la navegación.
      // Esta es una solución simple; una más robusta obtendría el rol desde la API.
      String role = 'residente'; // Rol por defecto
      if (_emailController.text.contains('seguridad')) {
        role = 'seguridad';
      } else if (_emailController.text.contains('mantenimiento')) {
        role = 'mantenimiento';
      }

      if (mounted) {
        // Le pasamos el 'role' a la DashboardPage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage(role: role)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/logo_main.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset('assets/images/logo_login.png', height: 110),
                      const SizedBox(height: 24.0),
                      Text('INICIAR SESIÓN',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email_outlined)),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline)),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 24.0),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _performLogin,
                              child: const Text('ENTRAR'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
