import 'package:flutter/material.dart';

import '../../widgets/app_menu_button.dart';
import '../../widgets/custom_bottom_nav.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Electronics', 'items': '24 items', 'icon': Icons.laptop_outlined},
    {'name': 'Bags', 'items': '12 items', 'icon': Icons.backpack_outlined},
    {'name': 'Wallets', 'items': '8 items', 'icon': Icons.account_balance_wallet_outlined},
    {'name': 'Keys', 'items': '17 items', 'icon': Icons.vpn_key_outlined},
    {'name': 'ID / Cards', 'items': '9 items', 'icon': Icons.badge_outlined},
    {'name': 'Books', 'items': '14 items', 'icon': Icons.menu_book_outlined},
    {'name': 'Clothing', 'items': '6 items', 'icon': Icons.checkroom_outlined},
    {'name': 'Accessories', 'items': '11 items', 'icon': Icons.watch_outlined},
    {'name': 'Others', 'items': '5 items', 'icon': Icons.category_outlined},
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
            Text(
              'Browse categories',
              style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Find a little of everything on campus',
              style: TextStyle(color: Colors.blueGrey, fontSize: 13),
            ),
          ],
        ),
        actions: const [AppMenuButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a category to explore lost and found items.',
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, index) {
                final item = _categories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE0E4EF)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'], size: 40, color: purple),
                      const SizedBox(height: 10),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF182237),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['items'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEDFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome, color: purple, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Not sure where it belongs?',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF182237)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Try searching a color, brand, or campus location.',
                          style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Shared Bottom Navigation Bar (no active item on a secondary screen)
      bottomNavigationBar: const CustomBottomNav(currentIndex: null),
    );
  }
}