import 'package:flutter_test/flutter_test.dart';

import 'package:test2/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LostFoundApp());
    expect(find.text('Lost & Found'), findsOneWidget);
  });
}
