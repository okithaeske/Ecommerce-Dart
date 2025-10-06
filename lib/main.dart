import 'package:ecommerce/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'routes/app_route.dart';
import 'services/connectivity_service.dart';
import 'services/sync_queue_service.dart';
import 'services/lexicon_service.dart';
import 'services/battery_service.dart';
import 'services/settings_service.dart';
import 'widgets/sensors_hud.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/home.dart';
import 'views/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive for lightweight local storage and caching
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox('cache'),
    Hive.openBox('sync_queue'),
    LexiconService.instance.loadFromAssets(),
  ]);

  // Initialize background services (connectivity + sync queue)
  SyncQueueService.instance; // ensure singleton constructed

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BatteryService()),
        ChangeNotifierProvider(create: (_) => SettingsService()),
      ],
      child: Builder(
        builder: (context) {
          final battery = context.watch<BatteryService>();
          final settings = context.watch<SettingsService>();
          final useBatteryTheme = settings.batteryThemeEnabled;
          final threshold = settings.batteryThemeThreshold;
          final themeMode =
              (useBatteryTheme &&
                      battery.level != null &&
                      battery.level! < threshold)
                  ? ThemeMode.dark
                  : ThemeMode.system;
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
              fontFamily: 'Montserrat',
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Montserrat',
                ),
              ),
              scaffoldBackgroundColor: const Color(0xFFF8F7F3),
              cardColor: Colors.white,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFD1B464),
                brightness: Brightness.dark,
              ),
              extensions: <ThemeExtension<dynamic>>[
                CustomColors(
                  heroTextColor: const Color.fromARGB(255, 217, 215, 210),
                  promoTextColor: const Color.fromARGB(255, 203, 202, 199),
                ),
              ],
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
            themeMode: themeMode,
            routes: AppRoutes.routes,
            // Route based on auth state without flashing login on cold start
            home: const _RootGate(),
            builder: (context, child) {
              final showHud =
                  context.watch<SettingsService>().sensorsHudEnabled;
              if (child == null) return const SizedBox.shrink();
              return Stack(children: [child, if (showHud) const SensorsHud()]);
            },
          );
        },
      ),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isRestoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Navigate based on auth state
    return auth.isAuthenticated ? Home() : LoginScreen();
  }
}
