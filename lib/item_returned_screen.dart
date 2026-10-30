import 'package:flutter/material.dart';

class ItemReturnedScreen extends StatefulWidget {
  const ItemReturnedScreen({super.key});

  @override
  State<ItemReturnedScreen> createState() => _ItemReturnedScreenState();
}

class _ItemReturnedScreenState extends State<ItemReturnedScreen> {
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Celebration Icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: Color(0xFFE6FFFA), shape: BoxShape.circle),
                child: const Center(child: Text('🎉', style: TextStyle(fontSize: 40))),
              ),
              const SizedBox(height: 20),

              const Text('Item Returned! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF182237))),
              const SizedBox(height: 8),
              const Text(
                'Your backpack is back where it belongs. A little kindness goes a long way.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.blueGrey, height: 1.4),
              ),
              const SizedBox(height: 24),

              // User Avatar & Name
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFEFEDFF),
                child: Text('SK', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 8),
              const Text('junaid Sarwar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF182237))),
              const SizedBox(height: 4),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(8)),
                child: const Text('Returned · iphone 15 pro max', style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              const Text('How was your experience with junaid?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF182237))),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
              Text('$_rating out of 5 · Wonderful!', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              const SizedBox(height: 24),

              // Thank you note
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Leave a thank-you (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              ),
              const SizedBox(height: 6),
              TextFormField(
                maxLines: 3,
                initialValue: 'Thank you for keeping my bag safe, Sara!',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                ),
              ),
              const SizedBox(height: 10),

              const Text('Returned at Library Desk · 8 Oct, 2:35 PM', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}