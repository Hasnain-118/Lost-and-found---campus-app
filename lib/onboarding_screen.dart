import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int currentPage = 0;

  final titles = [
    'Found something?',
    'Lost something?',
    'Find possible matches',
  ];

  final descriptions = [
    'Take a photo and help someone find their lost item.',
    'Search campus reports to find your belongings.',
    'Compare item details and locations to find a match.',
  ];

  // Icons ki jaga ab images ke paths
  final images = [
    'assets/images/found.png',
    'assets/images/lost.png',
    'assets/images/match.png',
  ];

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 440,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lost & Found',
                        style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: openLogin,
                        child: const Text('Skip'),
                      ),
                    ],
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      itemCount: titles.length,
                      onPageChanged: (index) {
                        setState(() => currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 32,
                          ),
                          child: Column(
                            children: [
                              // Yahan icon ki jaga image hai
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECEAF8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                    // Agar image na mile to ye dikhega
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 60,
                                          color: purple,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                titles[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                descriptions[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Text('${currentPage + 1} / ${titles.length}'),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (currentPage == titles.length - 1) {
                          openLogin();
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        currentPage == titles.length - 1
                            ? 'Get Started'
                            : 'Continue',
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: openLogin,
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}