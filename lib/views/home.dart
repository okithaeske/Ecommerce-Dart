import 'dart:async';
import 'package:ecommerce/views/screens/about_screen.dart';
import 'package:ecommerce/views/screens/contact_us_screen.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/product_screen.dart';
import 'package:ecommerce/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _selectedIndex = 0;
  bool _showNavBar = true;
  Timer? _hideTimer;

  final _pages = [
    HomeScreen(),
    AboutScreen(),
    ProductScreen(),
    ContactUsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      setState(() => _showNavBar = false);
    });
  }

  void _onUserInteraction() {
    if (!_showNavBar) {
      setState(() => _showNavBar = true);
    }
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: _onUserInteraction,
    onPanDown: (_) => _onUserInteraction(),
    child: WillPopScope(
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0; // Go to Home tab (or _selectedIndex - 1 for "previous" behavior)
          });
          return false; // Prevent the app from exiting
        }
        return true; // Exit the app
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 1,
          title: Text(
            "Zentara",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          iconTheme: IconThemeData(color: colorScheme.primary),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: _showNavBar
            ? AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                offset: Offset(0, 0),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: CustomBottomNavBar(
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      _onUserInteraction();
                      setState(() => _selectedIndex = index);
                    },
                  ),
                ),
              )
            : null,
      ),
    ),
  );
}
}
