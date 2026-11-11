import 'package:flutter/material.dart';

/// Circular profile picture shown in the navigation drawer and on the
/// profile screen.
///
/// Always built from the same local asset (`assets/images/my.jpg`), so both
/// places show the identical avatar design: a circular photo cropped with
/// [BoxFit.cover], a clean border and a subtle drop shadow.
class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    super.key,
    this.size = 56,
    this.borderColor = Colors.white,
  });

  /// Diameter of the circle.
  final double size;

  /// Color of the thin ring around the photo. White reads best on the purple
  /// drawer header; the app's soft border color works on light backgrounds.
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEFEDFF),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/my.jpg',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
