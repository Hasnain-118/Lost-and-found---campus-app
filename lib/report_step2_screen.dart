import 'package:flutter/material.dart';

class ReportStep2Screen extends StatelessWidget {
  const ReportStep2Screen({super.key});

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
          'Tell us about the item',
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
                  Text('STEP 2 OF 3', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Details', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFE0E4EF), borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              const SizedBox(height: 20),

              // Form Fields
              const Text('Item name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Navy Herschel backpack',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: 'Bags',
                          decoration: _inputStyle(),
                          items: ['Bags', 'Electronics', 'Keys'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: 'Navy blue',
                          decoration: _inputStyle(),
                          items: ['Navy blue', 'Black', 'Red'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Herschel',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 16),

              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                maxLines: 3,
                initialValue: 'Navy canvas backpack with tan straps. Found on the bench by the library entrance.',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: '08 Oct 2026',
                          decoration: _inputStyle().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blueGrey)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Time found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: '10:20 AM',
                          decoration: _inputStyle().copyWith(suffixIcon: const Icon(Icons.access_time, size: 18, color: Colors.blueGrey)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text('Add a secret detail to verify the owner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Inside pocket: a small red notebook',
                decoration: _inputStyle().copyWith(suffixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.blueGrey)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Only you can see the secret detail. We’ll ask claimants to describe it before returning the item.',
                style: TextStyle(fontSize: 11, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Button navigation updated to open ReportStep3Screen
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/report-step3');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_forward, size: 18),
                      SizedBox(width: 8),
                      Text('Continue to location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
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