import 'login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const Color purple = Color(0xFF5140EB);

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.add_photo_alternate_outlined,
      'title': 'Found something? Post it in seconds',
      'description':
      'A small act of kindness can make someone’s day. '
          'Snap a photo and help it find its way home.',
    },
    {
      'icon': Icons.search_rounded,
      'title': 'Lost something? Search and track it',
      'description':
      'From your favourite bottle to your laptop. '
          'Search across campus and keep every report in one place.',
    },
    {
      'icon': Icons.compare_arrows_rounded,
      'title': 'Find possible matches faster',
      'description':
      'Compare lost and found reports using item details, '
          'categories, and campus locations.',
    },
  ];

  void _continue() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _openLogin();
    }
  }

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Top bar.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          tooltip: 'Previous page',
                          onPressed: () {
                            _controller.previousPage(
                              duration:
                              const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: purple,
                          ),
                        ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Lost & Found',
                            style: TextStyle(
                              color: purple,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _openLogin,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF7B879C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Swipeable pages.
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // Illustration placeholder.
                            AspectRatio(
                              aspectRatio: 1.15,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECEAF8),
                                  borderRadius:
                                  BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(28),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      page['icon'] as IconData,
                                      size: 76,
                                      color: purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Progress indicators.
                            Row(
                              children: List.generate(
                                _pages.length,
                                    (dotIndex) {
                                  final selected =
                                      dotIndex == index;

                                  return Container(
                                    margin: const EdgeInsets.only(
                                      right: 5,
                                    ),
                                    width: selected ? 24 : 8,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? purple
                                          : const Color(
                                        0xFFDDDAF5,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              page['title'] as String,
                              style: const TextStyle(
                                fontSize: 26,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF182237),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              page['description'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: Color(0xFF7B879C),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEDFF),
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Built for your campus community',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom actions.
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _continue,
                          style: FilledButton.styleFrom(
                            backgroundColor: purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Get Started'
                                    : 'Continue',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _openLogin,
                        child: const Text(
                          'Already part of campus? Log in',
                          style: TextStyle(
                            color: Color(0xFF7B879C),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}