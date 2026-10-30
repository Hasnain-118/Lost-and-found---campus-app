import 'package:flutter/material.dart';

class ReportScanningScreen extends StatelessWidget {
  const ReportScanningScreen({super.key});

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
        title: const Text('Report submitted', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Radar Graphic Container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE6FFFA),
                  border: Border.all(color: const Color(0xFF319795).withValues(alpha: 0.3), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF319795), width: 2),
                    ),
                    child: const Icon(Icons.radar, color: Color(0xFF319795), size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'We’re scanning found\nitems...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF182237)),
              ),
              const SizedBox(height: 8),
              const Text(
                'You’re not searching alone. We’ll notify you as soon as a likely match appears.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Item Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E4EF)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/bagpack.png', width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Navy backpack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
                        const SizedBox(height: 2),
                        const Text('Report L-1084 · Library · 10:00 AM', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Lost', style: TextStyle(fontSize: 10, color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Loading Bar Box
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Loading state · comparing details', style: TextStyle(color: purple, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 5,
                      backgroundColor: Color(0xFFE0E4EF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Checking category, color, location, and description.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                ],
              ),
              const SizedBox(height: 16),

              // Match Empty Status Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E4EF)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search_off_outlined, color: purple, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No matches yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                          SizedBox(height: 2),
                          Text('Your search stays active. New reports are checked automatically.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFEDFF),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/possible-matches');
                  },
                  child: const Text('Possible matches', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}