import 'package:flutter/material.dart';

class AppTheme {
  // Hacemos el constructor privado para que nadie pueda instanciar esta clase.
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    // Esquema de colores principal de la aplicación
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF003366), // Un azul oscuro y profesional
      primary: const Color(0xFF003366),
      secondary: const Color(0xFF4D8AF0), // Un azul más brillante para acentos
    ),

    // Tema para los AppBars
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF003366),
      foregroundColor: Colors.white, // Color del texto y los íconos
      elevation: 4.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Tema para los botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Tema para los campos de texto
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFF003366), width: 2.0),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
    ),

    // Tema para las tarjetas (Cards)
    cardTheme: CardThemeData(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Usar Material 3
    useMaterial3: true,
  );
}
