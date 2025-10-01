import 'dart:async';
import 'dart:math' as math;
import 'package:ecommerce/views/screens/about_screen.dart';
import 'package:ecommerce/views/screens/contact_us_screen.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/product_screen.dart';
import 'package:ecommerce/views/screens/cart_screen.dart';
import 'package:ecommerce/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/routes/app_route.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

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

  late final List<Widget> _pages;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime? _lastShake;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    _pages = const [
      HomeScreen(),
      AboutScreen(),
      ProductScreen(),
      ContactUsScreen(),
    ];
    _initShakeToScan();
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
    _accelSub?.cancel();
    super.dispose();
  }

  void _initShakeToScan() {
    _accelSub = accelerometerEventStream().listen((e) {
      final gX = e.x / 9.80665;
      final gY = e.y / 9.80665;
      final gZ = e.z / 9.80665;
      final gForce = math.sqrt(gX * gX + gY * gY + gZ * gZ);
      if (gForce > 2.4) {
        final now = DateTime.now();
        if (_lastShake == null || now.difference(_lastShake!) > const Duration(seconds: 3)) {
          _lastShake = now;
          if (mounted) {
            Navigator.pushNamed(context, AppRoutes.scanner);
          }
        }
      }
    });
  }

 @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: _onUserInteraction,
    onPanDown: (_) => _onUserInteraction(),
    child: PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0; // Go to Home tab
          });
        }
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
            // Cart icon with badge
            Builder(
              builder: (context) {
                final cartCount = context.watch<CartProvider>().totalCount;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      tooltip: 'Cart',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          ],
        ),
        body: _buildPageWithCartHook(_pages[_selectedIndex]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.sensors),
          tooltip: 'Sensors',
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.black,
          child: const Icon(Icons.sensors),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  // Injects cart-aware props into ProductScreen when present
  Widget _buildPageWithCartHook(Widget page) {
    if (page is ProductScreen) {
      final cartCount = context.watch<CartProvider>().totalCount;
      return ProductScreen(
        onCartTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CartScreen()),
        ),
        cartCount: cartCount,
      );
    }
    return page;
  }
}
