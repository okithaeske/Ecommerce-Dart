import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class CheckoutApi {
  final String baseUrl;
  final http.Client _client;

  CheckoutApi({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> submitOrder({
    required String token,
    required String tokenType,
    required Map<String, dynamic> payload,
  }) async {
    await _ensureOnline();
    final uri = Uri.parse('$baseUrl/checkout');
    final response = await _client.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $token',
      },
      body: jsonEncode(payload),
    );

    final decoded = _decodeBody(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{};
    }

    final message =
        _extractMessage(decoded) ?? 'Checkout failed (${response.statusCode})';
    throw Exception(message);
  }

  Future<void> _ensureOnline() async {
    final results = await Connectivity().checkConnectivity();
    final online = results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
    if (!online) {
      throw Exception('No internet connection');
    }
  }

  dynamic _decodeBody(String body) {
    if (body.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final key in ['message', 'error']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
      final errors = data['errors'];
      if (errors is Map) {
        for (final entry in errors.values) {
          if (entry is List) {
            for (final message in entry) {
              if (message is String && message.trim().isNotEmpty) {
                return message;
              }
            }
          } else if (entry is String && entry.trim().isNotEmpty) {
            return entry;
          }
        }
      }
    } else if (data is List) {
      for (final entry in data) {
        if (entry is String && entry.trim().isNotEmpty) {
          return entry;
        }
      }
    }
    return null;
  }
}
