import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String _tokenType = 'Bearer';
  Map<String, dynamic>? _user;

  String? get token => _token;
  String get tokenType => _tokenType;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void setAuth({required String token, String tokenType = 'Bearer', Map<String, dynamic>? user}) {
    _token = token;
    _tokenType = tokenType;
    _user = user;
    notifyListeners();
  }

  void clear() {
    _token = null;
    _user = null;
    _tokenType = 'Bearer';
    notifyListeners();
  }
}

