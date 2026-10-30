import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'categories_screen.dart';
import 'around_campus_screen.dart';
import 'report_selection_screen.dart';
import 'report_step1_screen.dart';
import 'report_step2_screen.dart';
import 'report_step3_screen.dart';
import 'report_success_screen.dart';
import 'report_lost_item_screen.dart';
import 'possible_matches_screen.dart';
import 'match_details_screen.dart';
import 'confirm_claim_screen.dart';
import 'report_scanning_screen.dart';
import 'item_returned_screen.dart';
import 'chats_screen.dart';
import 'chat_details_screen.dart';
import 'plan_return_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const LostAndFoundApp());
}

class LostAndFoundApp extends StatelessWidget {
  const LostAndFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lost & Found',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/around-campus': (context) => const AroundCampusScreen(),
        '/report-selection': (context) => const ReportSelectionScreen(),
        '/report-step1': (context) => const ReportStep1Screen(),
        '/report-step2': (context) => const ReportStep2Screen(),
        '/report-step3': (context) => const ReportStep3Screen(),
        '/report-success': (context) => const ReportSuccessScreen(),
        '/report-lost': (context) => const ReportLostItemScreen(),
        '/possible-matches': (context) => const PossibleMatchesScreen(),
        '/match-details': (context) => const MatchDetailsScreen(),
        '/confirm-claim': (context) => const ConfirmClaimScreen(),
        '/report-scanning': (context) => const ReportScanningScreen(),
        '/item-returned': (context) => const ItemReturnedScreen(),
        '/chats': (context) => const ChatsScreen(),
        '/chat-detail': (context) => const ChatDetailScreen(),
        '/plan-return': (context) => const PlanReturnScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF35299B),
              Color(0xFF5140EB),
              Color(0xFF8C84FC),
            ],
          ),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.travel_explore, size: 80, color: Colors.white),
                      SizedBox(height: 20),
                      Text('Lost & Found', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 10),
                      Text('Lost it? Found it. Return it.', style: TextStyle(fontSize: 15, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Text('A LITTLE CARE. A CLOSER CAMPUS.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, letterSpacing: 1.4, color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}