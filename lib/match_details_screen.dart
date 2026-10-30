import 'package:flutter/material.dart';

class MatchDetailsScreen extends StatelessWidget {
  const MatchDetailsScreen({super.key});

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
        title: const Text('Looks like yours?', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comparison Cards
              Row(
                children: [
                  Expanded(
                    child: _buildItemCompareCard(
                      tag: 'Your Lost Item',
                      title: 'Navy Herschel backpack',
                      status: 'Lost',
                      statusBg: const Color(0xFFFFF3E0),
                      statusColor: const Color(0xFFE65100),
                      location: 'Library · 8 Oct',
                      imageAsset: 'assets/images/bagpack.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildItemCompareCard(
                      tag: 'Found Item',
                      title: 'iphone 14 pro max',
                      status: 'Found',
                      statusBg: const Color(0xFFE8F8F0),
                      statusColor: const Color(0xFF059669),
                      location: 'Cafe · 10 Oct',
                      imageAsset: 'assets/images/phone.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Match Score Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF10B981), width: 5),
                      ),
                      child: const Center(
                        child: Text(
                          '94%',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF182237)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('A strong match', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
                    const SizedBox(height: 4),
                    const Text('These reports share the details that matter.', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Score Breakdown List
              _buildProgressRow('Category', 1.0, '100%'),
              _buildProgressRow('Color', 0.95, '95%'),
              _buildProgressRow('Location', 0.80, '80%'),
              _buildProgressRow('Description', 0.70, '70%'),

              const SizedBox(height: 16),
              const Text(
                'Overall score also considers brand and unique details. Your answers help the finder confirm ownership.',
                style: TextStyle(fontSize: 11, color: Colors.blueGrey, height: 1.3),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/confirm-claim');
                  },
                  child: const Text('Verify & claim this item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCompareCard({
    required String tag,
    required String title,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required String location,
    required String imageAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E4EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageAsset,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.backpack, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
            child: Text(status, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 6),
          Text(location, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String title, double value, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF182237)))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0E4EF),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(percentage, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
        ],
      ),
    );
  }
}