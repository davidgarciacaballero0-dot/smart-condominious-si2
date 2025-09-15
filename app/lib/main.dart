import 'package:flutter/material.dart';
import 'login_page.dart'; // Importamos la nueva página de login

void main() {
  runApp(const SmartCondominiumApp());
}

class SmartCondominiumApp extends StatelessWidget {
  const SmartCondominiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Condominium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // La pantalla inicial de la app es LoginPage
      home: const LoginPage(),
    );
  }
}
