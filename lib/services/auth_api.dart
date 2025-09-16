import 'dart:convert';
import 'package:http/http.dart' as http;

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
}

