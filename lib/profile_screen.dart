import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text('My campus profile', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF182237)),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFEFEDFF),
                    child: Text('AM', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Junaid Sarwar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
                      const SizedBox(height: 2),
                      const Text('Software engineering · Fa24-BSE-067', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Verified campus member', style: TextStyle(fontSize: 10, color: purple, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE0E4EF))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('4', 'Items Returned'),
                    _buildStatItem('7', 'Reports'),
                    _buildStatItem('98%', 'Trust Score', color: purple),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('My reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildTabChip('My Lost · 2', false),
                  const SizedBox(width: 8),
                  _buildTabChip('My Found · 3', false),
                  const SizedBox(width: 8),
                  _buildTabChip('Returned · 4', true),
                ],
              ),
              const SizedBox(height: 16),

              // Item Cards List
              _buildReportItemCard('Navy Herschel backpack', 'Library Desk · Today, 2:35 PM', 'Returned', 'assets/images/bag.png'),
              _buildReportItemCard('University ID card', 'Security Office · 6 Oct', 'Returned', 'assets/images/wallet.png'),
              _buildReportItemCard('Sage insulated bottle', 'Sports Complex · 2 Oct', 'Returned', 'assets/images/bottle.png'),

              const SizedBox(height: 16),
              const Center(
                child: Text('A little care, a closer campus. Thanks for being part of it.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildStatItem(String val, String label, {Color? color}) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color ?? const Color(0xFF182237))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildTabChip(String label, bool isSelected) {
    const purple = Color(0xFF5140EB);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isSelected ? const Color(0xFFEFEDFF) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: isSelected ? purple : Colors.blueGrey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
    );
  }

  Widget _buildReportItemCard(String title, String subtitle, String status, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE0E4EF))),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(image, width: 48, height: 48, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(6)),
                  child: Text(status, style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}