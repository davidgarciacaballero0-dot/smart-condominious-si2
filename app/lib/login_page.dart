// ignore_for_file: unused_import, deprecated_member_use, undefined_hidden_name

import 'package:app/security_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'models/profile_models.dart';
import 'maintenance_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // ... (resto del archivo sin cambios)

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    String email = _emailController.text;
    String password = _passwordController.text;
    Widget? homePage;

    // --- LÓGICA DE ROLES ---
    if (email == "residente@email.com" && password == "123456") {
      homePage = const DashboardPage(); // Vista de Residente
    } else if (email == "seguridad@email.com" && password == "123456") {
      homePage = const SecurityDashboardPage(); // Vista de Seguridad
    } else if (email == "mantenimiento@email.com" && password == "123456") {
      homePage = const MaintenanceDashboardPage(); // Vista de Mantenimiento
    }

    if (mounted) {
      if (homePage != null) {
        Navigator.of(context).pushReplacement(
          // --- AQUÍ ESTÁ LA CORRECCIÓN ---
          MaterialPageRoute(builder: (context) => homePage!),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Credenciales incorrectas.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

// ... (resto del archivo sin cambios)

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- IMAGEN DE FONDO ---
          Image.asset(
            'assets/images/logo_main.png',
            fit: BoxFit.cover,
            color:
                Colors.black.withOpacity(0.5), // Velo oscuro para legibilidad
            colorBlendMode: BlendMode.darken,
          ),
          // --- FORMULARIO CENTRADO ---
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
                      Image.asset(
                        'assets/images/logo_main.png',
                        height: 110, // Tamaño final del logo
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'INICIAR SESIÓN',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
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
