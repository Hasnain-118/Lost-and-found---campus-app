import 'package:flutter_test/flutter_test.dart';
import 'package:test2/main.dart';
import 'package:test2/screens/auth/login_screen.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LostAndFoundApp());
    await tester.pump();

    // The app starts on the splash screen.
    expect(find.byType(SplashScreen), findsOneWidget);

    // After the splash delay the app lands on the login screen — Home is
    // only reachable after a successful login.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
