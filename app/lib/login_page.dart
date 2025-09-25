// ignore_for_file: unused_field, unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'security_dashboard_page.dart';
import 'maintenance_dashboard_page.dart';
import 'services/api_service.dart'; // <-- Importamos nuestro servicio de API
import 'package:jwt_decode/jwt_decode.dart'; // <-- Importaremos un paquete para leer el token

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instancia del servicio
  bool _isLoading = false;

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (result['success'] == true && mounted) {
        // Si el login es exitoso, leemos el rol desde el token guardado
        final token = await _apiService.getAuthToken();
        if (token != null) {
          Map<String, dynamic> payload = Jwt.parseJwt(token);
          String userRole = payload['role'] ??
              'residente'; // Asumimos residente si no hay rol

          Widget homePage;
          switch (userRole) {
            case 'security':
              homePage = const SecurityDashboardPage();
              break;
            case 'maintenance':
              homePage = const MaintenanceDashboardPage();
              break;
            default:
              homePage = const DashboardPage();
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => homePage),
          );
        }
      } else {
        _showError(result['message'] ?? 'Ocurrió un error');
      }
    } catch (e) {
      _showError('No se pudo conectar al servidor.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // El widget build no cambia...
    return Scaffold(
      body: Stack(
          // ...
          ),
    );
  }
}
