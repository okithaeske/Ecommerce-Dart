import 'package:ecommerce/views/screens/about_screen.dart';
import 'package:ecommerce/views/screens/contact_us_screen.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/product_screen.dart';
import 'package:ecommerce/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _selectedIndex = 0;

  final _pages = [
    HomeScreen(),
    AboutScreen(),
    ProductScreen(),
    ContactUsScreen(),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface, // Adapts!
        elevation: 1,
        title: Text(
          "Zentara",
          style: TextStyle(
            color: colorScheme.onSurface, // Themed text color
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary), // Themed icon color
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
