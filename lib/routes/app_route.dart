

import 'package:ecommerce/views/home.dart';
import 'package:ecommerce/views/login.dart';
import 'package:ecommerce/views/register.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const register = '/register';

  static final routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(), // Assuming the same screen for registration
    home: (context) => Home(),

  };
}
