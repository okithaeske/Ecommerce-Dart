import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Material(
        elevation: isDark ? 0 : 12,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        color: colorScheme.surface,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: colorScheme.surface,
            elevation: 0, // Remove default elevation
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurface.withOpacity(0.62),
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: colorScheme.primary,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface.withOpacity(0.68),
            ),
            iconSize: 24,
            selectedFontSize: 13,
            unselectedFontSize: 12,
            // Better ripple on tap
            enableFeedback: true,
            items: [
              _luxNavBarItem(
                context,
                icon: Icons.home,
                label: "Home",
                selected: currentIndex == 0,
                colorScheme: colorScheme,
              ),
              _luxNavBarItem(
                context,
                icon: Icons.info_outline_rounded,
                label: "About",
                selected: currentIndex == 1,
                colorScheme: colorScheme,
              ),
              _luxNavBarItem(
                context,
                icon: Icons.shopping_cart,
                label: "Cart",
                selected: currentIndex == 2,
                colorScheme: colorScheme,
              ),
              _luxNavBarItem(
                context,
                icon: Icons.phone_rounded,
                label: "Contact Us",
                selected: currentIndex == 3,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _luxNavBarItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required ColorScheme colorScheme,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: colorScheme.primary.withOpacity(0.11),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.11),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              )
            : null,
        child: Icon(
          icon,
          size: selected ? 26 : 22,
          color: selected
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.62),
        ),
      ),
      label: label,
    );
  }
}
