import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

void main() {
  runApp(const LostFoundApp());
}

class LostFoundApp extends StatelessWidget {
  const LostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Lost & Found',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5140EB),
        ),
      ),
      home: const SplashScreen(),
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
    _openOnboarding();
  }

  Future<void> _openOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF35299B),
              Color(0xFF5140EB),
              Color(0xFF8C84FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content occupies the available space.
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo background.
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0x26FFFFFF),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(0x40FFFFFF),
                            ),
                          ),
                          child: const Icon(
                            Icons.travel_explore_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Lost & Found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Lost it? Found it. Return it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom tagline.
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 30),
                child: Text(
                  'A LITTLE CARE. A CLOSER CAMPUS.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
