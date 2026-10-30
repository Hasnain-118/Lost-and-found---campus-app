import 'package:flutter/material.dart';

class ReportSelectionScreen extends StatelessWidget {
  const ReportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF182237)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Make a report',
          style: TextStyle(
            color: Color(0xFF182237),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How can we help?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF182237),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Every report brings someone one step closer to their belongings.',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Card 1: I Lost Something -> Opens /report-lost screen
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/report-lost');
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFFEF3C7),
                        child: Icon(Icons.search, color: Color(0xFFD97706), size: 22),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'I Lost Something',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF182237),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tell us what’s missing. We’ll look for a match across campus.',
                        style: TextStyle(fontSize: 13, color: Colors.blueGrey, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Text(
                            'Start a report',
                            style: TextStyle(
                              color: Color(0xFFD97706),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16, color: Color(0xFFD97706)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card 2: I Found Something -> Opens /report-step1 screen
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/report-step1');
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFD1FAE5),
                        child: Icon(Icons.volunteer_activism_outlined, color: Color(0xFF059669), size: 22),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'I Found Something',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF182237),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Share a photo and a few details. Help it get back to its owner.',
                        style: TextStyle(fontSize: 13, color: Colors.blueGrey, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Text(
                            'Start a report',
                            style: TextStyle(
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16, color: Color(0xFF059669)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Bottom Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEDFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.favorite_outline, color: purple, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You’re in good company\n128 items returned by your campus this month.',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}