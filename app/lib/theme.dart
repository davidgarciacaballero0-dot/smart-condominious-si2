import 'package:flutter/material.dart';

// Paleta de colores extraída de tus diseños.
class AppColors {
  static const Color primaryBlue =
      Color(0xFF005A9C); // Azul principal de la barra y botones
  static const Color accentGold = Color(0xFFEAA700); // Dorado del logo
  static const Color lightGrey = Color(0xFFF5F7FA); // Fondo de la pantalla
  static const Color darkText = Color(0xFF333333); // Texto principal oscuro
  static const Color lightText = Color(0xFF757575); // Texto secundario gris
}

// Tema principal de la aplicación, configurado según tus diseños.
final ThemeData appTheme = ThemeData(
  // Esquema de colores global
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    primary: AppColors.primaryBlue,
    secondary: AppColors.accentGold,
    // ignore: deprecated_member_use
    background: AppColors.lightGrey,
    brightness: Brightness.light,
  ),

  // Color de fondo para la mayoría de las pantallas
  scaffoldBackgroundColor: AppColors.lightGrey,

  // Tema de la barra de aplicación (AppBar)
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    elevation: 0, // Una apariencia más plana y moderna
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),

  // Tema para los campos de texto
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2.0),
    ),
    labelStyle: const TextStyle(color: AppColors.lightText),
  ),

  // Tema para los botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // Tema para las tarjetas
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 4.0,
    // ignore: deprecated_member_use
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
  ),

  // Tema de la tipografía
  textTheme: const TextTheme(
    // Para títulos grandes como "INICIAR SESIÓN"
    titleLarge: TextStyle(
        color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 22),
    // Para el texto dentro de los botones o tarjetas
    titleMedium: TextStyle(
        color: AppColors.darkText, fontWeight: FontWeight.w600, fontSize: 18),
    // Para el texto normal
    bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16),
    // Para texto secundario o etiquetas
    bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 14),
  ),
);
