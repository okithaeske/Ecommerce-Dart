import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String _tokenType = 'Bearer';
  Map<String, dynamic>? _user;
  bool _isRestoring = true;

  String? get token => _token;
  String get tokenType => _tokenType;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get isRestoring => _isRestoring;

  AuthProvider() {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final tokenType = prefs.getString('auth_token_type') ?? 'Bearer';
    final hasUser = prefs.containsKey('auth_user_name');
    if (token != null && token.isNotEmpty) {
      _token = token;
      _tokenType = tokenType;
      if (hasUser) {
        _user = {
          'name': prefs.getString('auth_user_name'),
          'email': prefs.getString('auth_user_email'),
          'id': prefs.getString('auth_user_id'),
        }..removeWhere((key, value) => value == null);
      }
    }
    _isRestoring = false;
    notifyListeners();
  }

  Future<void> setAuth({required String token, String tokenType = 'Bearer', Map<String, dynamic>? user}) async {
    _token = token;
    _tokenType = tokenType;
    _user = user;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_token_type', tokenType);
    if (user != null) {
      // Persist a few common fields if available
      if (user['id'] != null) {
        await prefs.setString('auth_user_id', user['id'].toString());
      }
      if (user['name'] != null) {
        await prefs.setString('auth_user_name', user['name'].toString());
      }
      if (user['email'] != null) {
        await prefs.setString('auth_user_email', user['email'].toString());
      }
    }
  }

  Future<void> clear() async {
    _token = null;
    _user = null;
    _tokenType = 'Bearer';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_token_type');
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_user_name');
    await prefs.remove('auth_user_email');
  }
}
