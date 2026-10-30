import 'package:flutter/material.dart';

class ReportStep3Screen extends StatefulWidget {
  const ReportStep3Screen({super.key});

  @override
  State<ReportStep3Screen> createState() => _ReportStep3ScreenState();
}

class _ReportStep3ScreenState extends State<ReportStep3Screen> {
  String _selectedHandover = 'I\'ll keep it';

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
        title: const Text(
          'Location & handover',
          style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('STEP 3 OF 3', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Location', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              const SizedBox(height: 20),

              // Map Graphic Container
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Container(
                        width: 80,
                        height: 45,
                        decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.location_on, color: purple, size: 18),
                            SizedBox(width: 4),
                            Text('Central Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF182237))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Where did you find it?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: 'Central Library',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
                ),
                items: ['Central Library', 'Cafeteria', 'Block A'].map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                onChanged: (v) {},
              ),
              const SizedBox(height: 10),

              Row(
                children: ['Library', 'Cafeteria', 'Block A'].map((chip) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEDFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(chip, style: const TextStyle(color: purple, fontSize: 12, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text('Who will keep it safe?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
              const SizedBox(height: 10),

              // Option 1
              GestureDetector(
                onTap: () => setState(() => _selectedHandover = 'I\'ll keep it'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedHandover == 'I\'ll keep it' ? purple : const Color(0xFFE0E4EF), width: _selectedHandover == 'I\'ll keep it' ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(_selectedHandover == 'I\'ll keep it' ? Icons.check_circle : Icons.radio_button_unchecked, color: _selectedHandover == 'I\'ll keep it' ? purple : Colors.grey),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('I\'ll keep it', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF182237))),
                          SizedBox(height: 2),
                          Text('Meet the verified owner on campus.', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Option 2
              GestureDetector(
                onTap: () => setState(() => _selectedHandover = 'Handed to Security Office'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedHandover == 'Handed to Security Office' ? purple : const Color(0xFFE0E4EF), width: _selectedHandover == 'Handed to Security Office' ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(_selectedHandover == 'Handed to Security Office' ? Icons.check_circle : Icons.radio_button_unchecked, color: _selectedHandover == 'Handed to Security Office' ? purple : Colors.grey),
                      const SizedBox(width: 12),
                      const Text('Handed to Security Office', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF182237))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Review summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
              const SizedBox(height: 10),

              // Summary Card with Image
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
                      child: Image.asset(
                        'assets/images/backpack.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.backpack, size: 40, color: purple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Navy Herschel backpack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
                        const SizedBox(height: 4),
                        const Text('Library · 8 Oct, 10:20 AM', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Found', style: TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Your secret detail stays private. You can update the handover location anytime.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/report-success');
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Submit found item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}