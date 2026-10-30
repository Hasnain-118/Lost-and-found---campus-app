import 'package:flutter/material.dart';

class ConfirmClaimScreen extends StatelessWidget {
  const ConfirmClaimScreen({super.key});

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
        title: const Text('Confirm it’s yours', style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Match Box
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
                      child: Image.asset('assets/images/bagpack.png', width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Navy Herschel backpack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF182237))),
                          const SizedBox(height: 2),
                          const Text('Found by Sara · Report F-2084', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(6)),
                                child: const Text('Matched', style: TextStyle(fontSize: 10, color: purple, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(6)),
                                child: const Text('94% match', style: TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text('Answer Sara\'s questions. These details won\'t appear on the public report.', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
              const SizedBox(height: 16),

              const Text('What is inside the front pocket?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'A small red notebook',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 14),

              const Text('Describe a distinctive mark or feature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Tan leather straps; scratch on buckle',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 14),

              const Text('Where did you last leave it?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Library entrance bench at 10 AM',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 16),

              // Upload Proof Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E4EF), style: BorderStyle.solid),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.upload_file_outlined, color: purple, size: 24),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add proof photo or receipt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        SizedBox(height: 2),
                        Text('Optional · JPG, PNG or PDF · up to 10 MB', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Note Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    Icon(Icons.verified_user_outlined, color: purple, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('What happens next?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                          SizedBox(height: 2),
                          Text('Sara reviews your answers. Once approved, chat opens so you can arrange a safe return.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/item-returned');
                  },
                  icon: const Icon(Icons.verified_outlined, size: 18),
                  label: const Text('Submit Claim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputStyle() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E4EF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF5140EB), width: 2)),
    );
  }
}