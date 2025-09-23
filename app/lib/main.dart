// ignore_for_file: unused_import, unnecessary_const

import 'package:app/dashboard_page.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. IMPORTA EL PAQUETE

void main() async {
  // <-- 2. CONVIERTE main EN ASÍNCRONO
  WidgetsFlutterBinding
      .ensureInitialized(); // Necesario para esperar la inicialización
  await initializeDateFormatting('es_ES', null); // <-- 3. INICIALIZA EL IDIOMA
  runApp(const SmartCondominiumApp());
}

class SmartCondominiumApp extends StatelessWidget {
  const SmartCondominiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    const loginPage = const LoginPage();
    return MaterialApp(
      title: 'Smart Condominium',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: loginPage,
    );
  }
}
