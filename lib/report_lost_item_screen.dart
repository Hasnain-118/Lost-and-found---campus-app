import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  bool _offerReward = false;
  XFile? _selectedPhoto;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedPhoto = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo select karne mein masla hua: $e')),
      );
    }
  }

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
          'Report a lost item',
          style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive Photo Upload Card
              GestureDetector(
                onTap: _pickImage,
                child: Container(
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
                        child: _selectedPhoto != null
                            ? (kIsWeb
                            ? Image.network(_selectedPhoto!.path, width: 50, height: 50, fit: BoxFit.cover)
                            : Image.file(File(_selectedPhoto!.path), width: 50, height: 50, fit: BoxFit.cover))
                            : Image.asset(
                          'assets/images/backpack.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 36, color: purple),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Add a photo (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                            SizedBox(height: 2),
                            Text('Upload from camera or gallery', style: TextStyle(fontSize: 11, color: purple)),
                          ],
                        ),
                      ),
                      const Icon(Icons.add_photo_alternate_outlined, color: purple, size: 22),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

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

              const Text('Unique identifiers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Tan straps; red notebook inside',
                decoration: _inputStyle(),
              ),
              const SizedBox(height: 16),

              const Text('Last-seen location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'Central Library entrance',
                decoration: _inputStyle().copyWith(suffixIcon: const Icon(Icons.location_on_outlined, size: 18, color: Colors.blueGrey)),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last-seen date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
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
                        const Text('Last-seen time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: '10:00 AM',
                          decoration: _inputStyle().copyWith(suffixIcon: const Icon(Icons.access_time, size: 18, color: Colors.blueGrey)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reward Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Offer a reward', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                      SizedBox(height: 2),
                      Text('Optional · a simple thank-you is enough', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                    ],
                  ),
                  Switch(
                    value: _offerReward,
                    activeColor: purple,
                    onChanged: (val) => setState(() => _offerReward = val),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(6)),
                child: const Text('Lost report · visible to campus', style: TextStyle(color: Color(0xFFE65100), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              // Navigates to Scanning Screen
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/report-scanning');
                  },
                  child: const Text('Submit lost report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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