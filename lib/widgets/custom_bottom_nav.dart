import 'package:flutter/material.dart';

import '../navigation/main_shell.dart';

/// Shared bottom navigation bar used across the authenticated app.
///
/// Contains exactly five items in a fixed order:
/// Home, Search, Report, Chats, Profile.
///
/// Layout rules that keep the bar tidy on every screen size:
///
/// * Every item owns exactly one fifth of the bar width ([Expanded]), so the
///   spacing between the five items is always equal.
/// * Every item reserves the same [_iconBandHeight] for its icon — tab icons
///   are centred inside it while the central Report button fills it — so all
///   five icons align vertically and all five labels share one baseline.
/// * The bar paints full-bleed down to the bottom of the screen while its
///   content avoids the system bottom inset ([SafeArea]).
///
/// Behaviour:
///
/// * Tab items switch the central [MainShell] tab — they never stack
///   duplicate screens and always land back on the single shell.
/// * The central Report button opens the existing report chooser flow.
/// * [currentIndex] is the bottom bar slot (0 Home, 1 Search, 2 Report,
///   3 Chats, 4 Profile), or `null` when the bar is shown on a secondary
///   screen that is not one of the five destinations (no active item).
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key, this.currentIndex});

  final int? currentIndex;

  /// Height every item reserves for its icon area. The central Report button
  /// fills this band completely while each tab icon is centred within it,
  /// which keeps the five labels on one shared baseline.
  static const double _iconBandHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Row(
              children: [
                _buildNavItem(context, icon: Icons.home_rounded, label: 'Home', slot: 0, tabIndex: 0),
                _buildNavItem(context, icon: Icons.search_rounded, label: 'Search', slot: 1, tabIndex: 1),
                _buildReportButton(context),
                _buildNavItem(context, icon: Icons.chat_bubble_outline_rounded, label: 'Chats', slot: 3, tabIndex: 2),
                _buildNavItem(context, icon: Icons.person_outline_rounded, label: 'Profile', slot: 4, tabIndex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Central Report action — the prominent purple rounded square with a white
  /// plus icon, sitting in the same icon band as the tab icons so every
  /// label lines up on one baseline.
  Widget _buildReportButton(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Expanded(
      child: GestureDetector(
        key: const ValueKey('bottom_nav_Report'),
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pushNamed(context, '/report-selection'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _iconBandHeight,
              width: double.infinity,
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: purple.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Report',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int slot,
    required int tabIndex,
  }) {
    const purple = Color(0xFF5140EB);
    final isSelected = currentIndex == slot;

    return Expanded(
      child: InkWell(
        key: ValueKey('bottom_nav_$label'),
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!isSelected) {
            MainShell.goToTab(context, tabIndex);
          }
        },
        child: Container(
          // Transparent decoration makes the whole cell the tap target.
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _iconBandHeight,
                width: double.infinity,
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected ? purple : Colors.blueGrey,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? purple : Colors.blueGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
