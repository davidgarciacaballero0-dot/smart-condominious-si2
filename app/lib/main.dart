import 'package:app/theme.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package.flutter/material.dart';
import 'package:app/login_page.dart';
// ignore: unused_import
import 'app_theme.dart';

void main() {
  runApp(const SmartCondominiumApp());
}

class SmartCondominiumApp extends StatelessWidget {
  const SmartCondominiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Condominium',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginPage(),
    );
  }
}
