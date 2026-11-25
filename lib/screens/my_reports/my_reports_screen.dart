import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_menu_button.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  static const _sampleReports = [
    {
      'title': 'Navy Herschel backpack',
      'subtitle': 'Library Desk · Today, 2:35 PM',
      'type': 'Lost',
      'status': 'Searching',
      'image': 'assets/images/bag.png',
    },
    {
      'title': 'University ID card',
      'subtitle': 'Security Office · 6 Oct',
      'type': 'Lost',
      'status': 'Returned',
      'image': 'assets/images/wallet.png',
    },
    {
      'title': 'Sage insulated bottle',
      'subtitle': 'Sports Complex · 2 Oct',
      'type': 'Found',
      'status': 'Returned',
      'image': 'assets/images/bottle.png',
    },
    {
      'title': 'Silver laptop',
      'subtitle': 'Cafeteria · 28 Sep',
      'type': 'Found',
      'status': 'Handover planned',
      'image': 'assets/images/phone.png',
    },
    {
      'title': 'Keys with teal keyring',
      'subtitle': 'Block A entrance · 21 Sep',
      'type': 'Found',
      'status': 'Reported',
      'image': 'assets/images/bag.png',
    },
    {
      'title': 'Black umbrella',
      'subtitle': 'Bus stop shelter · 12 Sep',
      'type': 'Found',
      'status': 'Returned',
      'image': 'assets/images/backpack.png',
    },
    {
      'title': 'Leather wallet',
      'subtitle': 'Block A · 30 Aug',
      'type': 'Lost',
      'status': 'Returned',
      'image': 'assets/images/wallet.png',
    },
    {
      'title': 'Wireless earbuds',
      'subtitle': 'Gym locker room · 18 Aug',
      'type': 'Lost',
      'status': 'Returned',
      'image': 'assets/images/phone.png',
    },
    {
      'title': 'Calculator',
      'subtitle': 'Exam hall · 2 Aug',
      'type': 'Found',
      'status': 'Returned',
      'image': 'assets/images/bottle.png',
    },
  ];

  int _selectedFilter = 0;

  String _imageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'bags':
        return 'assets/images/backpack.png';
      case 'electronics':
        return 'assets/images/phone.png';
      case 'keys':
        return 'assets/images/wallet.png';
      default:
        return 'assets/images/bag.png';
    }
  }

  List _firestoreToReportMaps(QuerySnapshot? snapshot) {
    if (snapshot == null) return [];
    final items = [];

    for (final doc in snapshot.docs) {
      final raw = doc.data();
      final data = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      final itemName = (data['itemName'] ?? 'Untitled item').toString().trim();
      final location =
      (data['lastSeenLocation'] ?? 'Campus').toString().trim();
      final date = (data['lastSeenDate'] ?? '').toString().trim();
      final time = (data['lastSeenTime'] ?? '').toString().trim();
      final category = (data['category'] ?? '').toString().trim();
      final rawStatus = (data['status'] ?? 'open').toString().trim();

      final dateTimeParts = [
        if (date.isNotEmpty) date,
        if (time.isNotEmpty) time,
      ].join(' · ');

      final subtitle =
      dateTimeParts.isNotEmpty ? '$location · $dateTimeParts' : location;

      final statusLabel =
      rawStatus.toLowerCase() == 'returned' ? 'Returned' : 'Searching';

      items.add({
        'title': itemName.isEmpty ? 'Untitled item' : itemName,
        'subtitle': subtitle,
        'type': 'Lost',
        'status': statusLabel,
        'image': _imageForCategory(category),
      });
    }
    return items;
  }

  List _applyFilter(List allReports) {
    switch (_selectedFilter) {
      case 0:
        return allReports
            .where((report) => report['type'] == 'Lost')
            .toList();
      case 1:
        return allReports
            .where((report) => report['type'] == 'Found')
            .toList();
      default:
        return allReports
            .where((report) => report['status'] == 'Returned')
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      key: const ValueKey('my_reports_screen'),
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF182237)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My reports',
          style: TextStyle(
            color: Color(0xFF182237),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [AppMenuButton()],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('lost_items')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            final liveLostReports = _firestoreToReportMaps(snapshot.data);
            final combinedReports = [
              ...liveLostReports,
              ..._sampleReports,
            ];

            final lostCount =
                combinedReports.where((r) => r['type'] == 'Lost').length;
            final foundCount =
                combinedReports.where((r) => r['type'] == 'Found').length;
            final returnedCount =
                combinedReports.where((r) => r['status'] == 'Returned').length;

            final reports = _applyFilter(combinedReports);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Everything you\'ve reported on campus',
                    style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  Row(
                    children: [
                      _buildFilterChip(
                        'My Lost · $lostCount',
                        _selectedFilter == 0,
                            () => setState(() => _selectedFilter = 0),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'My Found · $foundCount',
                        _selectedFilter == 1,
                            () => setState(() => _selectedFilter = 1),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Returned · $returnedCount',
                        _selectedFilter == 2,
                            () => setState(() => _selectedFilter = 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Live updates unavailable right now; showing saved list.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),

                  // Report Cards
                  if (reports.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E4EF)),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: Colors.blueGrey,
                            size: 36,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nothing here yet',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...reports.map(
                          (report) => _buildReportCard(report),
                    ),

                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'A little care, a closer campus. Thanks for being part of it.',
                      style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    const purple = Color(0xFF5140EB);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFEDFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
            isSelected ? const Color(0xFFEFEDFF) : const Color(0xFFE0E4EF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? purple : Colors.blueGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map report) {
    const purple = Color(0xFF5140EB);
    final isReturned = report['status'] == 'Returned';

    return Container(
      key: ValueKey('my_report_${report['title']}_${report['subtitle']}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E4EF)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              report['image'].toString(),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFEFEDFF),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: purple,
                    size: 22,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['title'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report['subtitle'].toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: report['type'] == 'Lost'
                            ? const Color(0xFFEFEDFF)
                            : const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report['type'].toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: report['type'] == 'Lost'
                              ? purple
                              : const Color(0xFF059669),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isReturned
                            ? const Color(0xFFE8F8F0)
                            : const Color(0xFFEFEDFF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report['status'].toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isReturned ? const Color(0xFF059669) : purple,
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
  }
}