import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_system_explorer/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SolarSystemApp());
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Mission-ready solar system exploration for the classroom.',
      ),
      findsOneWidget,
    );
    expect(find.text('Enter Mission Control'), findsOneWidget);
  });
}
