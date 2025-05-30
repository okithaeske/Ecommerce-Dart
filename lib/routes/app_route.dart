

import 'package:ecommerce/views/home.dart';
import 'package:ecommerce/views/login.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';

  static final routes = {
    login: (context) => LoginScreen(),
    home: (context) => Home(),
  };
}
