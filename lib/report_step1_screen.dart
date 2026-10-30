import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportStep1Screen extends StatefulWidget {
  const ReportStep1Screen({super.key});

  @override
  State<ReportStep1Screen> createState() => _ReportStep1ScreenState();
}

class _ReportStep1ScreenState extends State<ReportStep1Screen> {
  final List<XFile> _selectedPhotos = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedPhotos.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aap maximum 4 photos hi add kar sakte hain.')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedPhotos.add(pickedFile);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo select karne mein masla hua: $e')),
      );
    }
  }

  Widget _buildPhotoSlot(int index) {
    const purple = Color(0xFF5140EB);

    if (index < _selectedPhotos.length) {
      final photo = _selectedPhotos[index];
      return Stack(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E4EF)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: kIsWeb
                  ? Image.network(photo.path, fit: BoxFit.cover)
                  : Image.file(File(photo.path), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPhotos.removeAt(index);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    } else if (index == _selectedPhotos.length) {
      return GestureDetector(
        onTap: () => _pickImage(ImageSource.gallery),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEDFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: purple, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_a_photo_outlined, color: purple, size: 28),
              SizedBox(height: 6),
              Text('Add photo', style: TextStyle(color: purple, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E4EF)),
        ),
        child: const Center(child: Icon(Icons.add, color: Colors.grey, size: 28)),
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
          'Report a found item',
          style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('STEP 1 OF 3', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Photos', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFE0E4EF), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFE0E4EF), borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Show what you found',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF182237)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add up to 4 clear photos. Keep personal details out of view.',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildPhotoSlot(0)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPhotoSlot(1)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildPhotoSlot(2)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPhotoSlot(3)),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFE0E4EF)),
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined, color: purple, size: 18),
                      label: const Text('Camera', style: TextStyle(color: Color(0xFF182237))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFE0E4EF)),
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined, color: purple, size: 18),
                      label: const Text('Gallery', style: TextStyle(color: Color(0xFF182237))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${_selectedPhotos.length} of 4 photos added',
                  style: const TextStyle(color: purple, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFEFEDFF), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: purple, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Photo tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF182237))),
                          SizedBox(height: 2),
                          Text('Use daylight, show the full item, and capture a distinctive feature.', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/report-step2');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_forward, size: 18),
                      SizedBox(width: 8),
                      Text('Continue to details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
}