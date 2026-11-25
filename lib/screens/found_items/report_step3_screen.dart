import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_menu_button.dart';

class ReportStep3Screen extends StatefulWidget {
  const ReportStep3Screen({super.key});

  @override
  State<ReportStep3Screen> createState() => _ReportStep3ScreenState();
}

class _ReportStep3ScreenState extends State<ReportStep3Screen> {
  static const List<String> _locations = [
    'Central Library',
    'Cafeteria',
    'Block A',
  ];

  String _selectedLocation = 'Central Library';
  String _selectedHandover = 'I\'ll keep it';
  bool _isSubmitting = false;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  String _chipToLocation(String chip) {
    if (chip == 'Library') return 'Central Library';
    return chip;
  }

  Future<void> _submitFoundItem(BuildContext context) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      final Map<String, dynamic> stepData = args is Map<String, dynamic>
          ? Map<String, dynamic>.from(args)
          : <String, dynamic>{};

      final user = FirebaseAuth.instance.currentUser;

      final String itemName =
      (stepData['itemName'] ?? 'Navy Herschel backpack').toString().trim();
      final String category =
      (stepData['category'] ?? 'Bags').toString().trim();
      final String color =
      (stepData['color'] ?? 'Navy blue').toString().trim();
      final String brand = (stepData['brand'] ?? 'Herschel').toString().trim();
      final String description = (stepData['description'] ??
          'Navy canvas backpack with tan straps. Found on the bench by the library entrance.')
          .toString()
          .trim();
      final String dateFound =
      (stepData['dateFound'] ?? '08 Oct 2026').toString().trim();
      final String timeFound =
      (stepData['timeFound'] ?? '10:20 AM').toString().trim();
      final String secretDetail =
      (stepData['secretDetail'] ?? '').toString().trim();
      final int photoCount = (stepData['photoCount'] as int?) ?? 0;
      final List<String> photoNames = (stepData['photoNames'] is List)
          ? List<String>.from(stepData['photoNames'] as List)
          : <String>[];

      await FirebaseFirestore.instance.collection('found_items').add({
        'type': 'found',
        'status': 'reported',
        'userId': user?.uid,
        'userEmail': user?.email,
        'itemName': itemName.isEmpty ? 'Navy Herschel backpack' : itemName,
        'category': category,
        'color': color,
        'brand': brand,
        'description': description,
        'dateFound': dateFound,
        'timeFound': timeFound,
        'secretDetail': secretDetail,
        'locationFound': _selectedLocation,
        'handoverOption': _selectedHandover,
        'photoCount': photoCount,
        'photoNames': photoNames,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushNamed(context, '/report-success');
    } on FirebaseException catch (e) {
      _showMessage(e.message ?? 'Firestore mein found item save nahi ho saka.');
    } catch (e) {
      _showMessage('Found item submit karte waqt masla aaya: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);
    const background = Color(0xFFF8F9FD);

    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> stepData = args is Map<String, dynamic>
        ? args
        : <String, dynamic>{};

    final String summaryTitle =
    (stepData['itemName'] ?? 'Navy Herschel backpack').toString().trim().isEmpty
        ? 'Navy Herschel backpack'
        : (stepData['itemName'] ?? 'Navy Herschel backpack').toString().trim();

    final String summaryDate =
    (stepData['dateFound'] ?? '8 Oct').toString().trim();
    final String summaryTime =
    (stepData['timeFound'] ?? '10:20 AM').toString().trim();
    final String summarySubtitle =
        '$_selectedLocation · $summaryDate, $summaryTime';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF182237)),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Location & handover',
          style: TextStyle(
            color: Color(0xFF182237),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: const [AppMenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Progress
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STEP 3 OF 3',
                    style: TextStyle(
                      color: purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Location',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: purple,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _selectedLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF182237),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Where did you find it?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF182237),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                  ),
                ),
                items: _locations
                    .map(
                      (loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc),
                  ),
                )
                    .toList(),
                onChanged: _isSubmitting
                    ? null
                    : (v) {
                  if (v != null) {
                    setState(() => _selectedLocation = v);
                  }
                },
              ),
              const SizedBox(height: 10),

              Row(
                children: ['Library', 'Cafeteria', 'Block A'].map((chip) {
                  final mapped = _chipToLocation(chip);
                  final isActive = _selectedLocation == mapped;
                  return GestureDetector(
                    onTap: _isSubmitting
                        ? null
                        : () => setState(() => _selectedLocation = mapped),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF5140EB)
                            : const Color(0xFFEFEDFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chip,
                        style: TextStyle(
                          color: isActive ? Colors.white : purple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text(
                'Who will keep it safe?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF182237),
                ),
              ),
              const SizedBox(height: 10),

              // Option 1
              GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () => setState(() => _selectedHandover = 'I\'ll keep it'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedHandover == 'I\'ll keep it'
                          ? purple
                          : const Color(0xFFE0E4EF),
                      width: _selectedHandover == 'I\'ll keep it' ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedHandover == 'I\'ll keep it'
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _selectedHandover == 'I\'ll keep it'
                            ? purple
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'I\'ll keep it',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF182237),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Meet the verified owner on campus.',
                            style:
                            TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Option 2
              GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () => setState(
                      () => _selectedHandover = 'Handed to Security Office',
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedHandover == 'Handed to Security Office'
                          ? purple
                          : const Color(0xFFE0E4EF),
                      width: _selectedHandover == 'Handed to Security Office'
                          ? 2
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedHandover == 'Handed to Security Office'
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _selectedHandover == 'Handed to Security Office'
                            ? purple
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Handed to Security Office',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF182237),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Review summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF182237),
                ),
              ),
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
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.backpack,
                          size: 40,
                          color: purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summaryTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            summarySubtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F0),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Found',
                              style: TextStyle(
                                fontSize: 10,
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
              ),
              const SizedBox(height: 8),
              const Text(
                'Your secret detail stays private. You can update the handover location anytime.',
                style: TextStyle(fontSize: 11, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed:
                  _isSubmitting ? null : () => _submitFoundItem(context),
                  icon: _isSubmitting
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check, size: 18),
                  label: const Text(
                    'Submit found item',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}