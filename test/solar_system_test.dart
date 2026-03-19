import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_system_explorer/main.dart';

void main() {
  testWidgets('App shows Live Info Box', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: const SolarSystemScreen(grade: 6),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('INFO BOX'), findsOneWidget);
    expect(find.text('ORBITING'), findsOneWidget);
  });

  testWidgets('Pause button toggles state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: const SolarSystemScreen(grade: 6),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);
    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Play'), findsOneWidget);
  });
}
