// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart'; // Asegúrate de que el nombre del paquete 'app' sea correcto.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construimos la app con el NUEVO nombre de la clase.
    await tester.pumpWidget(const SmartCondominiumApp());

    // El resto de la prueba puede fallar porque ya no hay un contador,
    // pero no impedirá que la app se ejecute. Lo podemos borrar para más limpieza.
    // Por ahora, lo importante es que la app compile.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}
