import 'package:agenda_citas/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('registra y muestra una cita', (WidgetTester tester) async {
    await tester.pumpWidget(const AgendaCitasApp());

    expect(find.text('Aún no hay citas'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));

    await tester.enterText(find.byType(TextField).at(0), 'Ana López');
    await tester.enterText(find.byType(TextField).at(1), '15/10/2026');
    await tester.enterText(find.byType(TextField).at(2), '10:30 AM');
    await tester.enterText(
      find.byType(TextField).at(3),
      'Reunión del proyecto',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar cita'));
    await tester.pump();

    expect(find.text('Ana López'), findsOneWidget);
    // La fecha y la hora también aparecen como ejemplos de los campos,
    // por eso basta comprobar que están visibles en la pantalla.
    expect(find.text('15/10/2026'), findsWidgets);
    expect(find.text('10:30 AM'), findsWidgets);
    expect(find.text('Reunión del proyecto'), findsOneWidget);
    expect(find.text('Aún no hay citas'), findsNothing);
  });
}
