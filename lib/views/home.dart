import 'package:ecommerce/views/login.dart';
import 'package:ecommerce/views/screens/about_screen.dart';
import 'package:ecommerce/views/screens/contact_us_screen.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/product_screen.dart';
import 'package:ecommerce/widgets/bottom_nav_bar.dart' show CustomBottomNavBar;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _selectedIndex = 0;

  final _pages = [
    HomeScreen(),
    AboutScreen(),
    ProductScreen(),
    // ServicesScreen(),
    // Add more pages as needed
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zentara"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
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
