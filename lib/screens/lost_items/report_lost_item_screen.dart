import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/app_menu_button.dart';

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController =
  TextEditingController(text: 'Navy Herschel backpack');
  final _brandController = TextEditingController(text: 'Herschel');
  final _identifiersController =
  TextEditingController(text: 'Tan straps; red notebook inside');
  final _locationController =
  TextEditingController(text: 'Central Library entrance');
  final _dateController = TextEditingController(text: '08 Oct 2026');
  final _timeController = TextEditingController(text: '10:00 AM');

  String _selectedCategory = 'Bags';
  String _selectedColor = 'Navy blue';
  bool _offerReward = false;
  bool _isSubmitting = false;

  XFile? _selectedPhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _itemNameController.dispose();
    _brandController.dispose();
    _identifiersController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _pickImage() async {
    if (_isSubmitting) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _selectedPhoto = pickedFile;
        });
      }
    } catch (e) {
      _showMessage('Photo select karne mein masla hua: $e');
    }
  }

  Future<void> _submitLostReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('lost_items').add({
        'type': 'lost',
        'status': 'open',
        'userId': user?.uid,
        'userEmail': user?.email,
        'itemName': _itemNameController.text.trim(),
        'category': _selectedCategory,
        'color': _selectedColor,
        'brand': _brandController.text.trim(),
        'uniqueIdentifiers': _identifiersController.text.trim(),
        'lastSeenLocation': _locationController.text.trim(),
        'lastSeenDate': _dateController.text.trim(),
        'lastSeenTime': _timeController.text.trim(),
        'offerReward': _offerReward,
        'hasPhoto': _selectedPhoto != null,
        'photoName': _selectedPhoto?.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      _showMessage('Lost report saved.');
      Navigator.pushNamed(context, '/report-scanning');
    } on FirebaseException catch (e) {
      _showMessage(e.message ?? 'Firestore mein report save nahi ho saki.');
    } catch (e) {
      _showMessage('Report submit karte waqt masla aaya: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
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
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Report a lost item',
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
          child: Form(
            key: _formKey,
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
                              ? Image.network(
                            _selectedPhoto!.path,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(_selectedPhoto!.path),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ))
                              : Image.asset(
                            'assets/images/backpack.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image,
                              size: 36,
                              color: purple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add a photo (optional)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF182237),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedPhoto != null
                                    ? _selectedPhoto!.name
                                    : 'Upload from camera or gallery',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: purple,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Item name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _itemNameController,
                  enabled: !_isSubmitting,
                  decoration: _inputStyle(),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: _inputStyle(),
                            items: ['Bags', 'Electronics', 'Keys']
                                .map(
                                  (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ),
                            )
                                .toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (v) {
                              if (v != null) {
                                setState(() => _selectedCategory = v);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Color',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedColor,
                            decoration: _inputStyle(),
                            items: ['Navy blue', 'Black', 'Red']
                                .map(
                                  (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ),
                            )
                                .toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (v) {
                              if (v != null) {
                                setState(() => _selectedColor = v);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Brand',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _brandController,
                  enabled: !_isSubmitting,
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Unique identifiers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _identifiersController,
                  enabled: !_isSubmitting,
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Last-seen location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _locationController,
                  enabled: !_isSubmitting,
                  decoration: _inputStyle().copyWith(
                    suffixIcon: const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last-seen date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _dateController,
                            enabled: !_isSubmitting,
                            decoration: _inputStyle().copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last-seen time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _timeController,
                            enabled: !_isSubmitting,
                            decoration: _inputStyle().copyWith(
                              suffixIcon: const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.blueGrey,
                              ),
                            ),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offer a reward',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF182237),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Optional · a simple thank-you is enough',
                          style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    Switch(
                      value: _offerReward,
                      activeColor: purple,
                      onChanged: _isSubmitting
                          ? null
                          : (val) => setState(() => _offerReward = val),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Lost report · visible to campus',
                    style: TextStyle(
                      color: Color(0xFFE65100),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Saves to Firestore and navigates to Scanning Screen
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitLostReport,
                    child: _isSubmitting
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Submit lost report',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5140EB), width: 2),
      ),
    );
  }
}