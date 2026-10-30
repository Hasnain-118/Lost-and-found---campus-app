import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class PossibleMatchesScreen extends StatelessWidget {
  const PossibleMatchesScreen({super.key});

  final List<Map<String, dynamic>> _matches = const [
    {
      'title': 'Navy Herschel backpack',
      'locationTime': 'Central Library · 10:20 AM',
      'matchScore': '94%',
      'scoreColor': Color(0xFF10B981),
      'subtitle': 'Same color, category, and location',
      'image': 'assets/images/backpack.png',
    },
    {
      'title': 'Navy canvas backpack',
      'locationTime': 'Block A · Yesterday',
      'matchScore': '78%',
      'scoreColor': Color(0xFFF59E0B),
      'subtitle': 'Same category and similar color',
      'image': 'assets/images/backpack.png',
    },
    {
      'title': 'Blue student backpack',
      'locationTime': 'Cafeteria · 6 Oct',
      'matchScore': '61%',
      'scoreColor': Color(0xFFF59E0B),
      'subtitle': 'Same category; nearby location',
      'image': 'assets/images/backpack.png',
    },
  ];

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Possible matches', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18)),
            Text('For your navy Herschel backpack', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(10)),
                        child: const Text('Best match first', style: TextStyle(color: purple, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('3 matches', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.tune, color: purple, size: 20),
                ],
              ),
              const SizedBox(height: 16),

              ..._matches.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE0E4EF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.backpack, size: 36, color: purple),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
                                const SizedBox(height: 2),
                                Text(item['locationTime'], style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                              ],
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: item['scoreColor'], width: 2.5),
                            ),
                            child: Center(
                              child: Text(
                                item['matchScore'],
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: item['scoreColor']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(item['subtitle'], style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFEDFF),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/match-details');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('View Match', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward, size: 14, color: purple),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'A match is a clue, not a guarantee. Verify before claiming.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}