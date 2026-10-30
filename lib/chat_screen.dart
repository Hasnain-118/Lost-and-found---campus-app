import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'Junaid Sarwar',
      'avatar': 'JS',
      'time': '2m',
      'item': 'iphone 15 pro max',
      'lastMsg': 'I can meet you at the Library Desk.',
      'unread': 2,
      'image': 'assets/images/phone.png',
    },
    {
      'name': 'Hasnain',
      'avatar': 'H',
      'time': '1h',
      'item': 'Keys with teal keyring',
      'lastMsg': 'Thanks, I\'ll check with security.',
      'unread': 1,
      'image': 'assets/images/wallet.png',
    },
    {
      'name': 'Minahil Rani',
      'avatar': 'MR',
      'time': 'Tue',
      'item': 'Silver laptop',
      'lastMsg': 'Glad we found the owner!',
      'unread': 0,
      'image': 'assets/images/phone.png',
    },
    {
      'name': 'Campus Security',
      'avatar': 'CS',
      'time': 'Mon',
      'item': 'University ID card',
      'lastMsg': 'Collected from the desk. Thank you.',
      'unread': 0,
      'image': 'assets/images/bottle.png',
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
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Chats', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 2),
            Text('Good conversations. Happy returns.', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Search Conversations Input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: purple),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All messages'),
                    selected: true,
                    selectedColor: const Color(0xFFEFEDFF),
                    side: BorderSide.none,
                    labelStyle: const TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 12),
                    onSelected: (v) {},
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Unread · 2'),
                    selected: false,
                    backgroundColor: Colors.transparent,
                    side: BorderSide.none,
                    labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    onSelected: (v) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Chat Items List
              ..._chats.map((chat) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/chat-details');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E4EF)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFEFEDFF),
                          child: Text(chat['avatar'], style: const TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
                                  Text(chat['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(chat['item'], style: const TextStyle(fontSize: 11, color: purple, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(chat['lastMsg'], style: const TextStyle(fontSize: 12, color: Colors.blueGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                chat['image'],
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.image, size: 30, color: purple),
                              ),
                            ),
                            if (chat['unread'] > 0) ...[
                              const SizedBox(height: 4),
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: purple,
                                child: Text('${chat['unread']}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 12),

              // Bottom Security Tip Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: purple, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keep conversations on campus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF182237))),
                          SizedBox(height: 2),
                          Text('Never share passwords, payment details, or verification codes.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}