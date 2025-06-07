import 'package:flutter/material.dart';
import 'routes/app_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Choose a luxury Google Font (optional, if using fonts)
    // final baseTextTheme = ThemeData.light().textTheme.apply(fontFamily: 'Montserrat');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zentara',
      theme: ThemeData(
        useMaterial3: true, // Makes all widgets feel more modern!
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD1B464),
          brightness: Brightness.light,
        ),
        fontFamily: 'Montserrat', // Make sure you add to pubspec.yaml
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Montserrat',
          ),
          // Customize more as needed!
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
        cardColor: Colors.white,
        // Add more widget themes here if needed!
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD1B464),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Montserrat',
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF181818),
        cardColor: const Color(0xFF232323),
        // Adjust dark backgrounds for luxury feel
      ),
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
    );
  }
}
