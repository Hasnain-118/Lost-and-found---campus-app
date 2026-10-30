import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test2/Main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}