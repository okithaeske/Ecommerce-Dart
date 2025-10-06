class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://zentara.duckdns.org/api';

  static Uri contactEndpoint() => Uri.parse('$baseUrl/contact');

  static Uri usersEndpoint([String? userId]) {
    if (userId == null || userId.isEmpty) {
      return Uri.parse('$baseUrl/users');
    }
    return Uri.parse('$baseUrl/users/$userId');
  }

  static Uri currentUserEndpoint() => Uri.parse('$baseUrl/user');
}