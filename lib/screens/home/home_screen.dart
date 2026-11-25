import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../navigation/main_shell.dart';
import '../../widgets/app_menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  final _categories = const [
    'All items',
    'Bags',
    'Electronics',
    'Keys',
  ];

  String _greetingName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim() ?? '';
    if (displayName.isNotEmpty) {
      return displayName.split(' ').first;
    }
    final email = user?.email?.trim() ?? '';
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return 'Junaid';
  }

  String _imageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'bags':
        return 'assets/images/backpack.png';
      case 'electronics':
        return 'assets/images/phone.png';
      case 'keys':
        return 'assets/images/wallet.png';
      default:
        return 'assets/images/backpack.png';
    }
  }

  List _mapFoundDocs(QuerySnapshot? snapshot) {
    if (snapshot == null) return [];
    final mapped = [];
    for (final doc in snapshot.docs) {
      final raw = doc.data();
      final data = raw != null
          ? Map<String, dynamic>.from(raw as Map)
          : <String, dynamic>{};
      final itemName = (data['itemName'] ?? 'Found item').toString().trim();
      final location = (data['locationFound'] ?? 'Campus').toString().trim();
      final timeFound = (data['timeFound'] ?? '').toString().trim();
      final category = (data['category'] ?? 'All items').toString().trim();
      final subtitle =
      timeFound.isNotEmpty ? '$location · $timeFound' : location;

      mapped.add({
        'title': itemName.isEmpty ? 'Found item' : itemName,
        'subtitle': subtitle,
        'status': 'Found',
        'category': category,
        'imageAsset': _imageForCategory(category),
      });
    }
    return mapped;
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);
    final selectedCategory = _categories[_selectedCategoryIndex];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Menu, Greeting and Working Notifications Button
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E4EF)),
                    ),
                    child: const AppMenuButton(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${_greetingName()} 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF182237),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Let’s bring your things back home.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E4EF)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      color: const Color(0xFF182237),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar -> Opens the Search Tab
              TextField(
                readOnly: true,
                onTap: () => MainShell.goToTab(context, 1),
                decoration: InputDecoration(
                  hintText: 'Search items, places, or keywords',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: purple),
                    onPressed: () => MainShell.goToTab(context, 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: purple, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Action Cards -> Directly Opens Report Selection Screen
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/report-selection'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.search,
                              color: Color(0xFFD97706),
                              size: 26,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'I Lost Something',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF182237),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/report-selection'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F0),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.volunteer_activism_outlined,
                              color: Color(0xFF059669),
                              size: 26,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'I Found Something',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF182237),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Categories Chips -> 'All items' opens Categories Screen
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_categories[index]),
                        selected: isSelected,
                        selectedColor: const Color(0xFFEFEDFF),
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: isSelected ? purple : Colors.blueGrey,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          if (index == 0) {
                            Navigator.pushNamed(context, '/categories');
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Section Header -> Around campus button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Found Near You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF182237),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/around-campus'),
                    child: const Text(
                      'Around campus',
                      style: TextStyle(
                        color: purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Live Firestore Found Items + Default Cards
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('found_items')
                    .orderBy('createdAt', descending: true)
                    .limit(4)
                    .snapshots(),
                builder: (context, snapshot) {
                  final defaultCards = [
                    {
                      'title': 'iPhone 14',
                      'subtitle': 'Cafeteria · 10m',
                      'status': 'Found',
                      'category': 'Electronics',
                      'imageAsset': 'assets/images/phone.png',
                    },
                    {
                      'title': 'Leather wallet',
                      'subtitle': 'Block A · 35m',
                      'status': 'Found',
                      'category': 'Keys',
                      'imageAsset': 'assets/images/wallet.png',
                    },
                  ];

                  final combinedCards = [
                    ..._mapFoundDocs(snapshot.data),
                    ...defaultCards,
                  ];

                  final filteredCards = _selectedCategoryIndex == 0
                      ? combinedCards
                      : combinedCards
                      .where(
                        (item) =>
                    item['category'].toString().toLowerCase() ==
                        selectedCategory.toLowerCase(),
                  )
                      .toList();

                  final displayCards =
                  filteredCards.isEmpty ? combinedCards : filteredCards;
                  final firstPair = displayCards.take(2).toList();

                  return Row(
                    children: [
                      for (int i = 0; i < firstPair.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: _buildItemCard(
                            title: firstPair[i]['title'].toString(),
                            subtitle: firstPair[i]['subtitle'].toString(),
                            status: firstPair[i]['status'].toString(),
                            imageAsset: firstPair[i]['imageAsset'].toString(),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Section Header: Possible Matches for You
              const Text(
                'Possible Matches for You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF182237),
                ),
              ),
              const SizedBox(height: 12),

              // Live Firestore Lost Items + Match Card Item
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('lost_items')
                    .orderBy('createdAt', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  String matchTitle = 'Navy Herschel backpack';
                  String matchSubtitle = 'Your navy backpack · Central Library';
                  String matchImage = 'assets/images/backpack.png';

                  final snapData = snapshot.data;
                  if (snapData != null && snapData.docs.isNotEmpty) {
                    final raw = snapData.docs.first.data();
                    final latestLost = raw != null
                        ? Map<String, dynamic>.from(raw as Map)
                        : <String, dynamic>{};
                    final lostName =
                    (latestLost['itemName'] ?? '').toString().trim();
                    final lostLoc =
                    (latestLost['lastSeenLocation'] ?? '').toString().trim();
                    final lostCat =
                    (latestLost['category'] ?? '').toString().trim();
                    if (lostName.isNotEmpty) matchTitle = lostName;
                    if (lostLoc.isNotEmpty) {
                      matchSubtitle = 'Reported lost · $lostLoc';
                    }
                    if (lostCat.isNotEmpty) {
                      matchImage = _imageForCategory(lostCat);
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE0E4EF)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECEAF8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              matchImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.backpack_outlined,
                                  color: purple,
                                  size: 36,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                matchTitle,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF182237),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                matchSubtitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFEDFF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Matched',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F8F0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '94% match',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF059669),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String subtitle,
    required String status,
    required String imageAsset,
  }) {
    const purple = Color(0xFF5140EB);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E4EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFECEAF8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: purple,
                      size: 36,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}