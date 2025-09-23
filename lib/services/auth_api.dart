import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthApi {
  final String baseUrl; // e.g. https://your-host/api
  final http.Client _client;

  AuthApi({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    final results = await Connectivity().checkConnectivity();
    final online = results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
    if (!online) {
      throw Exception('No internet connection');
    }
    final uri = Uri.parse('$baseUrl/login');
    final payload = {
      'email': email,
      'password': password,
      if (deviceName != null && deviceName.isNotEmpty) 'device_name': deviceName,
    };
    final res = await _client.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (data is Map<String, dynamic>) return data;
      throw Exception('Unexpected login response');
    }

    final message = (data is Map && data['message'] is String)
        ? data['message'] as String
        : 'Login failed (${res.statusCode})';
    throw Exception(message);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? passwordConfirmation,
  }) async {
    final results = await Connectivity().checkConnectivity();
    final online = results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
    if (!online) {
      throw Exception('No internet connection');
    }
    final uri = Uri.parse('$baseUrl/register');
    final payload = {
      'name': name,
      'email': email,
      'password': password,
      if (passwordConfirmation != null) 'password_confirmation': passwordConfirmation,
    };
    final res = await _client.post(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (data is Map<String, dynamic>) return data;
      throw Exception('Unexpected register response');
    }
    final message = (data is Map && data['message'] is String)
        ? data['message'] as String
        : 'Registration failed (${res.statusCode})';
    throw Exception(message);
  }
}
