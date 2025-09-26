// app/lib/main.dart

import 'package:flutter/material.dart';
import 'package:app/app_theme.dart';
import 'package:app/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- AÑADE ESTA IMPORTACIÓN

void main() async {
  // <-- CAMBIA A ASYNC
  // Asegura que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();
  // --- LÍNEA CLAVE QUE SOLUCIONA EL ERROR ---
  // Carga los datos de formato para el idioma español de Bolivia.
  await initializeDateFormatting('es_BO', null);

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
      home: const SplashScreen(),
    );
  }
}
