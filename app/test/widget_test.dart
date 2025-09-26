// app/test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App starts and shows SplashScreen', (WidgetTester tester) async {
    // Construimos nuestra app. Ya no necesita el parámetro isLoggedIn.
    await tester.pumpWidget(const MyApp());

    // Verificamos que la SplashScreen (la nueva pantalla de inicio)
    // muestra un CircularProgressIndicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
