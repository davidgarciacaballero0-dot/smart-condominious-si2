// lib/main.dart

// Importa tu nuevo archivo de tema
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_provider.dart';

@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MaterialApp(
      title: 'Smart Condominium',
      // Aplica el tema aquí
      theme: AppTheme.mainTheme,
      // ... el resto de tu configuración
    ),
  );
}
