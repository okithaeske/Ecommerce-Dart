

import 'package:ecommerce/views/home.dart';
import 'package:ecommerce/views/login.dart';
import 'package:ecommerce/views/register.dart';
import 'package:ecommerce/views/screens/sensors_screen.dart';
import 'package:ecommerce/views/screens/scanner_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const register = '/register';
  static const sensors = '/sensors';
  static const scanner = '/scanner';

  static final routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => Home(),
    sensors: (context) => const SensorsScreen(),
    scanner: (context) => const ScannerScreen(),
  };
}
