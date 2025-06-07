import 'package:ecommerce/views/screens/about_screen.dart';
import 'package:ecommerce/views/screens/contact_us_screen.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/product_screen.dart';
import 'package:ecommerce/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> get _pages => const [
    HomeScreen(),
    AboutScreen(),
    ProductScreen(),
    ContactUsScreen(),
    // Add more pages if needed
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Premium touch: system overlay for status bar (optional)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorScheme.surface,
      statusBarIconBrightness: colorScheme.brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 2,
          titleSpacing: 14,
          title: Row(
            children: [
              Icon(Icons.watch, color: colorScheme.primary, size: 27, semanticLabel: "Brand Logo"),
              const SizedBox(width: 8),
              Text(
                "Zentara",
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.2,
                  fontSize: 22,
                ),
                semanticsLabel: "Zentara Brand Title",
              ),
            ],
          ),
          iconTheme: IconThemeData(color: colorScheme.primary, size: 25),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: colorScheme.primary, size: 23),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              tooltip: 'Sign Out of Zentara',
            ),
          ],
        ),
        body: AnimatedSwitcher(
          key: ValueKey(_selectedIndex),
          duration: const Duration(milliseconds: 250),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
