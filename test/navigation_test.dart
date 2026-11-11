// Navigation system tests:
//  * the five bottom navigation bar items and their destinations,
//  * tab switching, active states, state preservation and no duplicates,
//  * the central Report action,
//  * every drawer item (including closing the drawer after selection),
//  * the shared my.jpg profile avatar in drawer and profile screen,
//  * navigation from secondary screens,
//  * back-button behaviour,
//  * auth screens staying free of the bar and drawer.
//
// Note: tabs inside the shell stay mounted (IndexedStack), and the shell
// itself stays mounted below pushed secondary routes, so finders are scoped
// with find.descendant where needed to stay unambiguous.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test2/navigation/main_shell.dart';
import 'package:test2/screens/auth/login_screen.dart';
import 'package:test2/screens/auth/reset_password_screen.dart';
import 'package:test2/screens/auth/signup_screen.dart';
import 'package:test2/screens/auth/verify_email_screen.dart';
import 'package:test2/screens/browse/categories_screen.dart';
import 'package:test2/screens/browse/search_screen.dart';
import 'package:test2/screens/chat/chats_screen.dart';
import 'package:test2/screens/home/home_screen.dart';
import 'package:test2/screens/my_reports/my_reports_screen.dart';
import 'package:test2/screens/onboarding/onboarding_screen.dart';
import 'package:test2/screens/profile/profile_screen.dart';
import 'package:test2/screens/report/report_selection_screen.dart';
import 'package:test2/screens/settings/settings_screen.dart';
import 'package:test2/widgets/app_menu_button.dart';
import 'package:test2/widgets/custom_bottom_nav.dart';
import 'package:test2/widgets/user_profile_avatar.dart';

const _purple = Color(0xFF5140EB);

Widget buildTestApp({String initialRoute = '/home'}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: initialRoute,
    routes: {
      '/home': (context) => const MainShell(),
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
      '/reset-password': (context) => const ResetPasswordScreen(),
      '/categories': (context) => const CategoriesScreen(),
      '/report-selection': (context) => const ReportSelectionScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/my-reports': (context) => const MyReportsScreen(),
    },
  );
}

/// Closes the modal filter sheet that the Search screen opens automatically.
Future<void> _closeAutoOpenedSheet(WidgetTester tester) async {
  final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
  if (navigator.canPop()) {
    navigator.pop();
    await tester.pumpAndSettle();
  }
}

/// Gives the test a taller, phone-like surface (800x1200). Several app screens
/// are designed for phone viewports and would overflow the default 800x600
/// test window.
Future<void> _usePhoneSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

/// Taps the custom arrow back button of the given screen. The app does not
/// use the standard Material back button everywhere, so [WidgetTester.pageBack]
/// cannot be used. The finder is scoped to [of] because routes below the top
/// one stay mounted in widget tests, which would make the tap ambiguous.
Future<void> _tapBackButton(WidgetTester tester, Finder of) async {
  await tester.tap(find.descendant(of: of, matching: find.byIcon(Icons.arrow_back)));
}

/// True when the given bottom nav item is in its active (purple) state.
bool _navItemSelected(WidgetTester tester, Finder navItem) {
  final icon = tester.widget<Icon>(
    find.descendant(of: navItem, matching: find.byType(Icon)),
  );
  return icon.color == _purple;
}

/// True when the given drawer tile is highlighted as the current destination.
bool _drawerTileSelected(WidgetTester tester, Finder tile) {
  final text = tester.widget<Text>(
    find.descendant(of: tile, matching: find.byType(Text)),
  );
  return text.style?.fontWeight == FontWeight.bold;
}

void main() {
  testWidgets('bottom navigation bar shows the five required items in order', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Exactly five items, in the required order.
    final bar = find.byType(CustomBottomNav);
    expect(bar, findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Home')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Search')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Report')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Chats')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Profile')), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);

    // The prominent central Report button keeps its purple rounded square
    // with the white plus icon.
    final reportIcon = tester.widget<Icon>(
      find.descendant(of: find.byKey(const ValueKey('bottom_nav_Report')), matching: find.byType(Icon)),
    );
    expect(reportIcon.color, Colors.white);
    expect(reportIcon.icon, Icons.add);

    // Home is the initial tab.
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Home'))), isTrue);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Chats'))), isFalse);
  });

  testWidgets('all five bottom navigation items navigate to their screens with correct active state', (tester) async {
    await _usePhoneSurface(tester);
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // 2. Search
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Search')));
    await tester.pumpAndSettle();
    expect(find.text('Find your item'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Search'))), isTrue);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Home'))), isFalse);
    await _closeAutoOpenedSheet(tester);

    // 3. Report pushes the existing report chooser on top of the shell.
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Report')));
    await tester.pumpAndSettle();
    expect(find.byType(ReportSelectionScreen), findsOneWidget);
    expect(find.text('Make a report'), findsOneWidget);

    // Back returns to the shell exactly where we left it (Search tab).
    await _tapBackButton(tester, find.byType(ReportSelectionScreen));
    await tester.pumpAndSettle();
    expect(find.text('Find your item'), findsOneWidget);
    expect(find.byType(ReportSelectionScreen), findsNothing);

    // 4. Chats
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Chats')));
    await tester.pumpAndSettle();
    expect(find.text('Good conversations. Happy returns.'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Chats'))), isTrue);

    // 5. Profile
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Profile')));
    await tester.pumpAndSettle();
    expect(find.text('My campus profile'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Profile'))), isTrue);

    // 1. Home
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Home')));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Home'))), isTrue);
  });

  testWidgets('tab taps never stack duplicate screens and preserve tab state', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    final homeStateBefore = tester.state<State<HomeScreen>>(find.byType(HomeScreen));

    // Tapping a tab repeatedly must not stack routes above the shell.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('bottom_nav_Chats')));
      await tester.pumpAndSettle();
    }
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    expect(navigator.canPop(), isFalse);
    expect(find.text('Good conversations. Happy returns.'), findsOneWidget);

    // Coming back to Home reuses the very same screen instance (state kept).
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Home')));
    await tester.pumpAndSettle();
    final homeStateAfter = tester.state<State<HomeScreen>>(find.byType(HomeScreen));
    expect(homeStateAfter, same(homeStateBefore));
  });

  testWidgets('tabs build lazily and stay mounted after being visited', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Home is the initial tab; Search must not be mounted yet so its filter
    // sheet only ever opens when the user actually visits the Search tab.
    expect(find.byType(SearchScreen, skipOffstage: false), findsNothing);
    expect(find.text('Filters'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('bottom_nav_Search')));
    await tester.pumpAndSettle();

    // First visit opens the auto filter sheet exactly once.
    expect(find.text('Filters'), findsOneWidget);
    await _closeAutoOpenedSheet(tester);

    // Once built, the tab stays mounted while other tabs are shown.
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Home')));
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(ChatsScreen, skipOffstage: false), findsNothing);
    expect(find.byType(ProfileScreen, skipOffstage: false), findsNothing);
  });

  testWidgets('drawer opens from the menu button, highlights the current destination and closes after selection', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();

    // Every required drawer item exists.
    expect(find.byKey(const ValueKey('drawer_user_profile')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Home')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Search')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Report Lost/Found')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Chats')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_My Reports')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Settings')), findsOneWidget);
    expect(find.byKey(const ValueKey('drawer_item_Logout')), findsOneWidget);

    // Current destination highlighted.
    expect(_drawerTileSelected(tester, find.byKey(const ValueKey('drawer_item_Home'))), isTrue);
    expect(_drawerTileSelected(tester, find.byKey(const ValueKey('drawer_item_Chats'))), isFalse);

    // Selecting Chats closes the drawer and switches tabs.
    await tester.tap(find.byKey(const ValueKey('drawer_item_Chats')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('app_drawer')), findsNothing);
    expect(find.text('Good conversations. Happy returns.'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Chats'))), isTrue);
  });

  testWidgets('drawer user profile opens the Profile tab', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_user_profile')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('app_drawer')), findsNothing);
    expect(find.text('My campus profile'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Profile'))), isTrue);
  });

  testWidgets('drawer and profile screen show the same my.jpg profile picture', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // The drawer header shows the shared avatar built from the local asset.
    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();

    final drawerAvatar = find.descendant(
      of: find.byKey(const ValueKey('app_drawer')),
      matching: find.byType(UserProfileAvatar),
    );
    expect(drawerAvatar, findsOneWidget);
    final drawerImage = tester.widget<Image>(
      find.descendant(of: drawerAvatar, matching: find.byType(Image)),
    );
    expect(drawerImage.image, const AssetImage('assets/images/my.jpg'));
    expect(drawerImage.fit, BoxFit.cover);

    // The profile screen header shows the identical avatar design.
    await tester.tap(find.byKey(const ValueKey('drawer_item_Home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('bottom_nav_Profile')));
    await tester.pumpAndSettle();

    final profileAvatar = find.descendant(
      of: find.byType(ProfileScreen),
      matching: find.byType(UserProfileAvatar),
    );
    expect(profileAvatar, findsOneWidget);
    final profileImage = tester.widget<Image>(
      find.descendant(of: profileAvatar, matching: find.byType(Image)),
    );
    expect(profileImage.image, const AssetImage('assets/images/my.jpg'));
    expect(profileImage.fit, BoxFit.cover);
  });

  testWidgets('drawer Search and Report Lost/Found navigate to their destinations', (tester) async {
    await _usePhoneSurface(tester);
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Search destination.
    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_Search')));
    await tester.pumpAndSettle();
    expect(find.text('Find your item'), findsOneWidget);
    await _closeAutoOpenedSheet(tester);

    // Report Lost/Found destination (existing chooser screen, on top of the shell).
    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_Report Lost/Found')));
    await tester.pumpAndSettle();
    expect(find.text('Make a report'), findsOneWidget);

    await _tapBackButton(tester, find.byType(ReportSelectionScreen));
    await tester.pumpAndSettle();
    expect(find.text('Find your item'), findsOneWidget);
  });

  testWidgets('drawer My Reports opens the my reports screen with working filters', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_My Reports')));
    await tester.pumpAndSettle();

    expect(find.byType(MyReportsScreen), findsOneWidget);
    expect(find.descendant(of: find.byType(MyReportsScreen), matching: find.text('Navy Herschel backpack')), findsOneWidget);

    // Filter chips switch the visible reports.
    await tester.tap(find.descendant(of: find.byType(MyReportsScreen), matching: find.text('My Found · 3')));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(MyReportsScreen), matching: find.text('Silver laptop')), findsOneWidget);
    expect(find.descendant(of: find.byType(MyReportsScreen), matching: find.text('Navy Herschel backpack')), findsNothing);

    // Back returns to the shell.
    await _tapBackButton(tester, find.byType(MyReportsScreen));
    await tester.pumpAndSettle();
    expect(find.byType(MyReportsScreen), findsNothing);
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
  });

  testWidgets('drawer Settings opens the settings screen with working back navigation', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_Settings')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);

    await _tapBackButton(tester, find.byType(SettingsScreen));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
  });

  testWidgets('drawer Logout signs out to the login screen and clears the app stack', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_Logout')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome back.'), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
    expect(find.byType(CustomBottomNav), findsNothing);
  });

  testWidgets('settings screen logout goes to the login screen', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer_item_Settings')));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(of: find.byType(SettingsScreen), matching: find.text('Log out')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
  });

  testWidgets('secondary screens keep the shared bar with no active item; tab switch and menu pop back to the shell', (tester) async {
    await _usePhoneSurface(tester);
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Open a secondary screen above the shell.
    final shellContext = tester.element(find.byKey(const ValueKey('bottom_nav_Home')));
    Navigator.pushNamed(shellContext, '/categories');
    await tester.pumpAndSettle();

    expect(find.byType(CategoriesScreen), findsOneWidget);

    // The categories screen shows the shared bar with NO falsely active item.
    final bar = find.descendant(of: find.byType(CategoriesScreen), matching: find.byType(CustomBottomNav));
    expect(bar, findsOneWidget);
    expect(_navItemSelected(tester, find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Home')))), isFalse);
    expect(_navItemSelected(tester, find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Search')))), isFalse);
    expect(_navItemSelected(tester, find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Chats')))), isFalse);
    expect(_navItemSelected(tester, find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Profile')))), isFalse);

    // The central Report action also works from a secondary screen.
    await tester.tap(find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Report'))));
    await tester.pumpAndSettle();
    expect(find.text('Make a report'), findsOneWidget);
    await _tapBackButton(tester, find.byType(ReportSelectionScreen));
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesScreen), findsOneWidget);

    // Tapping a tab from the secondary screen pops it and switches the shell
    // tab — no duplicate stacked screens.
    await tester.tap(find.descendant(of: bar, matching: find.byKey(const ValueKey('bottom_nav_Chats'))));
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesScreen), findsNothing);
    expect(find.text('Good conversations. Happy returns.'), findsOneWidget);

    // The menu button on a secondary screen pops back to the shell and opens
    // the drawer.
    await tester.tap(find.byKey(const ValueKey('app_menu_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('app_drawer')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('drawer_item_Home')));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
  });

  testWidgets('home screen search field switches to the Search tab', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('Find your item'), findsOneWidget);
    expect(_navItemSelected(tester, find.byKey(const ValueKey('bottom_nav_Search'))), isTrue);

    // The Search tab auto-opened its filter sheet — close it so that only the
    // shell route is left on the stack.
    await _closeAutoOpenedSheet(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    expect(navigator.canPop(), isFalse); // no stacked duplicate of the search screen
  });

  testWidgets('bottom bar and drawer menu never appear on auth screens', (tester) async {
    final authScreens = <Widget>[
      const LoginScreen(),
      const SignupScreen(),
      const ResetPasswordScreen(),
      const VerifyEmailScreen(email: 'junaid@campus.edu'),
      const OnboardingScreen(),
    ];

    for (final screen in authScreens) {
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: screen,
      ));
      await tester.pump();

      expect(find.byType(CustomBottomNav), findsNothing, reason: '${screen.runtimeType} must not show the bottom bar');
      expect(find.byType(AppMenuButton), findsNothing, reason: '${screen.runtimeType} must not show the drawer menu button');
    }
  });

  testWidgets('login links work and login lands on the shell (auth navigation stays separate)', (tester) async {
    await _usePhoneSurface(tester);
    await tester.pumpWidget(buildTestApp(initialRoute: '/login'));
    await tester.pumpAndSettle();

    // Previously broken: these routes were never registered.
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    await _tapBackButton(tester, find.byType(SignupScreen));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.byType(ResetPasswordScreen), findsOneWidget);
    await _tapBackButton(tester, find.byType(ResetPasswordScreen));
    await tester.pumpAndSettle();

    // Logging in replaces the whole auth stack with the shell.
    await tester.enterText(find.byType(TextFormField).first, 'junaid@campus.edu');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('Hi, Junaid 👋'), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom_nav_Home')), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    expect(navigator.canPop(), isFalse);
  });
}
