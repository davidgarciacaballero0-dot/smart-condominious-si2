// app/lib/main.dart

import 'package:flutter/material.dart';
import 'package:app/app_theme.dart';
import 'package:app/splash_screen.dart'; // <-- Importamos la nueva pantalla

void main() {
  // Ya no necesitamos que main() sea async
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Condominium',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // La SplashScreen es ahora el punto de entrada.
      // Ella decidirá a dónde navegar.
      home: const SplashScreen(),
    );
  }
}
