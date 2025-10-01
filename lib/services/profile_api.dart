import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}

class ProfileApi {
  final String baseUrl;
  final http.Client _client;

  ProfileApi({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchCurrentUser({
    required String token,
    required String tokenType,
    String? currentUserId,
  }) async {
    await _ensureOnline();
    final uri = Uri.parse('$baseUrl/user');
    final res = await _client.get(uri, headers: _headers(token, tokenType));
    final decoded = _decodeBody(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final user = _extractUser(decoded, currentUserId: currentUserId);
      if (user != null) {
        return user;
      }
      throw const ApiException('User information not found in response.');
    }

    throw _toException(res.statusCode, decoded);
  }

  Future<Map<String, dynamic>> updateUser({
    required String token,
    required String tokenType,
    required String userId,
    required Map<String, dynamic> payload,
    Map<String, dynamic>? currentUser,
  }) async {
    await _ensureOnline();
    final uri = Uri.parse('$baseUrl/users/$userId');
    final res = await _client.post(
      uri,
      headers: _headers(token, tokenType, hasBody: true),
      body: jsonEncode(payload),
    );
    final decoded = _decodeBody(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final user = _extractUser(decoded, currentUserId: userId);
      if (user != null) {
        return user;
      }
      final fallback = <String, dynamic>{
        if (currentUser != null) ...currentUser,
        ...payload,
        'id': userId,
      };
      return fallback;
    }

    throw _toException(res.statusCode, decoded);
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
      throw const ApiException('No internet connection.');
    }
  }

  Map<String, String> _headers(
    String token,
    String tokenType, {
    bool hasBody = false,
  }) {
    if (token.isEmpty) {
      throw const ApiException('Authentication token missing.');
    }
    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': '$tokenType $token',
    };
    if (hasBody) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
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

  ApiException _toException(int statusCode, dynamic decoded) {
    final message = _readMessage(decoded) ?? 'Request failed ($statusCode)';
    return ApiException(message, statusCode: statusCode);
  }

  String? _readMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      for (final key in ['message', 'error']) {
        final value = decoded[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
      final errors = decoded['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List) {
            for (final entry in value) {
              if (entry is String && entry.trim().isNotEmpty) {
                return entry;
              }
            }
          } else if (value is String && value.trim().isNotEmpty) {
            return value;
          }
        }
      }
    } else if (decoded is List) {
      for (final entry in decoded) {
        if (entry is String && entry.trim().isNotEmpty) {
          return entry;
        }
      }
    }
    return null;
  }

  Map<String, dynamic>? _extractUser(dynamic data, {String? currentUserId}) {
    if (data == null) {
      return null;
    }
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        final nested = _extractUser(data['data'], currentUserId: currentUserId);
        if (nested != null) return nested;
      }
      if (data.containsKey('user')) {
        final nested = _extractUser(data['user'], currentUserId: currentUserId);
        if (nested != null) return nested;
      }
      if (data.containsKey('users')) {
        final nested = _extractUser(
          data['users'],
          currentUserId: currentUserId,
        );
        if (nested != null) return nested;
      }
      if (_looksLikeUser(data)) {
        return Map<String, dynamic>.from(data);
      }
    }
    if (data is List) {
      final maps = data.whereType<Map<String, dynamic>>();
      if (maps.isEmpty) {
        return null;
      }
      if (currentUserId != null) {
        for (final map in maps) {
          final id = map['id'];
          if (id != null && id.toString() == currentUserId) {
            return Map<String, dynamic>.from(map);
          }
        }
      }
      return Map<String, dynamic>.from(maps.first);
    }
    return null;
  }

  bool _looksLikeUser(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final email = map['email'];
    return id != null && (name != null || email != null);
  }
}
