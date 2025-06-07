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
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    // Landscape tweaks: Hide labels and enlarge icons if desired
    final showLabels = !isLandscape || screenWidth > 700;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 40 : 0,
        ),
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
              elevation: 0,
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
              iconSize: isLandscape ? 30 : 24,
              selectedFontSize: showLabels ? 13 : 0,
              unselectedFontSize: showLabels ? 12 : 0,
              showSelectedLabels: showLabels,
              showUnselectedLabels: showLabels,
              enableFeedback: true,
              items: [
                _luxNavBarItem(
                  context,
                  icon: Icons.home,
                  label: "Home",
                  selected: currentIndex == 0,
                  colorScheme: colorScheme,
                  isLandscape: isLandscape,
                ),
                _luxNavBarItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  label: "About",
                  selected: currentIndex == 1,
                  colorScheme: colorScheme,
                  isLandscape: isLandscape,
                ),
                _luxNavBarItem(
                  context,
                  icon: Icons.shopping_cart,
                  label: "Cart",
                  selected: currentIndex == 2,
                  colorScheme: colorScheme,
                  isLandscape: isLandscape,
                ),
                _luxNavBarItem(
                  context,
                  icon: Icons.phone_rounded,
                  label: "Contact Us",
                  selected: currentIndex == 3,
                  colorScheme: colorScheme,
                  isLandscape: isLandscape,
                ),
              ],
            ),
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
    required bool isLandscape,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? 4 : 2,
          horizontal: 0,
        ),
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
          size: selected
              ? (isLandscape ? 34 : 26)
              : (isLandscape ? 26 : 22),
          color: selected
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.62),
        ),
      ),
      label: label,
    );
  }
}
