import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Navy backpack');
  List<String> _recentSearches = ['Navy backpack', 'Keys near Block A'];

  String _selectedCategory = 'Bags';
  String _selectedLocation = 'Library';
  String _selectedStatus = 'Found';
  int _selectedColorIndex = 0;

  final List<Color> _colorOptions = [
    const Color(0xFF2541B2),
    const Color(0xFF0F172A),
    Colors.white,
    const Color(0xFFD4B28C),
    const Color(0xFF10B981),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFilterBottomSheet();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            const purple = Color(0xFF5140EB);
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF182237),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedCategory = 'Bags';
                              _selectedStatus = 'Found';
                              _selectedColorIndex = 0;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEFEDFF),
                          ),
                          child: const Text('Reset', style: TextStyle(color: purple)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Bags', 'Electronics', 'All'].map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: const Color(0xFFEFEDFF),
                            labelStyle: TextStyle(
                              color: isSelected ? purple : Colors.blueGrey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              setModalState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date range', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E4EF)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Last 7 days', style: TextStyle(color: Colors.blueGrey)),
                                    Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blueGrey),
                                  ],
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
                              const Text('Campus location', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E4EF)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedLocation,
                                    isExpanded: true,
                                    items: ['Library', 'Cafeteria', 'Block A'].map((loc) {
                                      return DropdownMenuItem(value: loc, child: Text(loc));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setModalState(() => _selectedLocation = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(_colorOptions.length, (index) {
                          final isSelected = _selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () => setModalState(() => _selectedColorIndex = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? purple : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: _colorOptions[index],
                                child: _colorOptions[index] == Colors.white
                                    ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                )
                                    : null,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 6),
                        const Text('Navy selected', style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Found', 'Lost', 'Returned'].map((st) {
                        final isSelected = _selectedStatus == st;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(st),
                            selected: isSelected,
                            selectedColor: const Color(0xFFE8F8F0),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFF059669) : Colors.blueGrey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              setModalState(() => _selectedStatus = st);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Show 12 results', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
          'Find your item',
          style: TextStyle(color: Color(0xFF182237), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: purple),
                  onPressed: _showFilterBottomSheet,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E4EF)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Recent searches',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF182237)),
            ),
            const SizedBox(height: 12),

            ..._recentSearches.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.blueGrey, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item, style: const TextStyle(color: Colors.blueGrey)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _recentSearches.remove(item));
                      },
                      child: const Icon(Icons.close, color: Colors.blueGrey, size: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),

      // Bottom Nav Bar with working + Report action
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: _navItem(Icons.home_rounded, 'Home', false),
            ),
            _navItem(Icons.search_rounded, 'Search', true),

            // Middle Plus (+ Report) Button with Navigation
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/report-selection');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: purple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+ Report',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            _navItem(Icons.chat_bubble_outline_rounded, 'Chats', false),
            _navItem(Icons.person_outline_rounded, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isSelected) {
    const purple = Color(0xFF5140EB);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? purple : Colors.blueGrey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? purple : Colors.blueGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}