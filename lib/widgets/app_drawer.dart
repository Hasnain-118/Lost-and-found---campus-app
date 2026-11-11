import 'package:flutter/material.dart';

import '../navigation/main_shell.dart';
import 'user_profile_avatar.dart';

/// Central navigation drawer shown by [MainShell].
///
/// Contains the user profile header — rendered with the same shared
/// [UserProfileAvatar] the Profile screen uses, so the my.jpg picture and
/// its styling look identical in both places — and the main destinations
/// (Home, Search, Report Lost/Found, Chats, My Reports, Settings, Logout).
/// The currently selected tab is highlighted. The drawer always closes
/// itself before navigating to the chosen destination.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentTab});

  /// Currently selected shell tab: 0 Home, 1 Search, 2 Chats, 3 Profile.
  final int currentTab;

  void _selectTab(BuildContext context, int tabIndex) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Close the drawer first.
    MainShell.goToTab(context, tabIndex);
  }

  void _pushRoute(BuildContext context, String routeName) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Close the drawer first.
    navigator.pushNamed(routeName);
  }

  void _logout(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Close the drawer first.
    navigator.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Drawer(
      key: const ValueKey('app_drawer'),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User profile header.
            Material(
              color: purple,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
              child: InkWell(
                key: const ValueKey('drawer_user_profile'),
                onTap: () => _selectTab(context, 3),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 12, 20),
                  child: Row(
                    children: [
                      const UserProfileAvatar(size: 56, borderColor: Colors.white),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Junaid Sarwar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Software engineering · Fa24-BSE-067',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Main destinations.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTile(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: currentTab == 0,
                      onTap: () => _selectTab(context, 0),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.search_rounded,
                      label: 'Search',
                      selected: currentTab == 1,
                      onTap: () => _selectTab(context, 1),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Report Lost/Found',
                      selected: false,
                      onTap: () => _pushRoute(context, '/report-selection'),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Chats',
                      selected: currentTab == 2,
                      onTap: () => _selectTab(context, 2),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.receipt_long_rounded,
                      label: 'My Reports',
                      selected: false,
                      onTap: () => _pushRoute(context, '/my-reports'),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      selected: false,
                      onTap: () => _pushRoute(context, '/settings'),
                    ),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 6, 16, 10),
                      child: Divider(color: Color(0xFFE0E4EF), height: 1, thickness: 1),
                    ),

                    _buildTile(
                      context,
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      selected: false,
                      isDestructive: true,
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),

            // Footer.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Text(
                'Lost & Found · Campus',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// One destination row.
  ///
  /// The icon sits in a fixed 24x24 box so every row aligns its icon and
  /// label on exactly the same baselines, and the selected row is highlighted
  /// with the soft purple tint plus a small trailing dot.
  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    const purple = Color(0xFF5140EB);
    const dark = Color(0xFF182237);
    const tint = Color(0xFFEFEDFF);

    final Color foreground = isDestructive
        ? Colors.red
        : (selected ? purple : dark);
    final Color iconColor = isDestructive
        ? Colors.red
        : (selected ? purple : Colors.blueGrey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? tint : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: ValueKey('drawer_item_$label'),
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(child: Icon(icon, color: iconColor, size: 22)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: foreground,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: purple, shape: BoxShape.circle),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
