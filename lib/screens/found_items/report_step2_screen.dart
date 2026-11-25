import 'package:flutter/material.dart';

import '../../widgets/app_menu_button.dart';

class ReportStep2Screen extends StatefulWidget {
  const ReportStep2Screen({super.key});

  @override
  State<ReportStep2Screen> createState() => _ReportStep2ScreenState();
}

class _ReportStep2ScreenState extends State<ReportStep2Screen> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController =
  TextEditingController(text: 'Navy Herschel backpack');
  final _brandController = TextEditingController(text: 'Herschel');
  final _descriptionController = TextEditingController(
    text:
    'Navy canvas backpack with tan straps. Found on the bench by the library entrance.',
  );
  final _dateFoundController = TextEditingController(text: '08 Oct 2026');
  final _timeFoundController = TextEditingController(text: '10:20 AM');
  final _secretDetailController =
  TextEditingController(text: 'Inside pocket: a small red notebook');

  String _selectedCategory = 'Bags';
  String _selectedColor = 'Navy blue';

  @override
  void dispose() {
    _itemNameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _dateFoundController.dispose();
    _timeFoundController.dispose();
    _secretDetailController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  void _continueToLocation(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existingArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> payload = existingArgs is Map<String, dynamic>
        ? Map<String, dynamic>.from(existingArgs)
        : <String, dynamic>{};

    payload.addAll({
      'itemName': _itemNameController.text.trim(),
      'category': _selectedCategory,
      'color': _selectedColor,
      'brand': _brandController.text.trim(),
      'description': _descriptionController.text.trim(),
      'dateFound': _dateFoundController.text.trim(),
      'timeFound': _timeFoundController.text.trim(),
      'secretDetail': _secretDetailController.text.trim(),
    });

    Navigator.pushNamed(
      context,
      '/report-step3',
      arguments: payload,
    );
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
          'Tell us about the item',
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
                // Step Progress
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP 2 OF 3',
                      style: TextStyle(
                        color: purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Details',
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
                          color: const Color(0xFFE0E4EF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Form Fields
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
                            onChanged: (v) {
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
                            onChanged: (v) {
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
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
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
                            'Date found',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _dateFoundController,
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
                            'Time found',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF182237),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _timeFoundController,
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

                const Text(
                  'Add a secret detail to verify the owner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF182237),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _secretDetailController,
                  decoration: _inputStyle().copyWith(
                    suffixIcon: const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Only you can see the secret detail. We’ll ask claimants to describe it before returning the item.',
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),

                // Button navigation updated to open ReportStep3Screen with collected data
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
                    onPressed: () => _continueToLocation(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Continue to location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
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