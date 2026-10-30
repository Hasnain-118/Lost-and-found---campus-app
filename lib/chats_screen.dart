import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'Junaid Sarwar',
      'initials': 'JK',
      'item': 'iphone 14 pro max',
      'message': 'I can meet you at the Library Desk.',
      'time': '2m',
      'unread': 2,
      'image': 'assets/images/phone.png',
    },
    {
      'name': 'Hasnain Iftikhar',
      'initials': 'HI',
      'item': 'Keys with teal keyring',
      'message': 'Thanks, I\'ll check with security.',
      'time': '1h',
      'unread': 1,
      'image': 'assets/images/wallet.png',
    },
    {
      'name': 'Minahil Rani',
      'initials': 'MR',
      'item': 'Silver laptop',
      'message': 'Glad we found the owner!',
      'time': 'Tue',
      'unread': 0,
      'image': 'assets/images/phone.png',
    },
    {
      'name': 'Campus Security',
      'initials': 'CS',
      'item': 'University ID card',
      'message': 'Collected from the desk. Thank you.',
      'time': 'Mon',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chats', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
              const SizedBox(height: 4),
              const Text('Good conversations. Happy returns.', style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
              const SizedBox(height: 16),

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

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(10)),
                    child: const Text('All messages', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                    child: const Text('Unread · 2', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/chat-detail');
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
                              child: Text(chat['initials'], style: const TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 13)),
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
                                      Text(chat['time'], style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(chat['item'], style: const TextStyle(fontSize: 11, color: purple, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text(chat['message'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(chat['image'], width: 36, height: 36, fit: BoxFit.cover),
                                ),
                                if (chat['unread'] > 0) ...[
                                  const SizedBox(height: 6),
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: purple,
                                    child: Text('${chat['unread']}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: purple, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Keep conversations on campus\nNever share passwords, payment details, or verification codes.',
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey, height: 1.3),
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