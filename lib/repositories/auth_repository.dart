import 'package:ecommerce/services/auth_api.dart';

class AuthRepository {
  final AuthApi api;
  AuthRepository(this.api);

  Future<({String token, String tokenType, Map<String, dynamic> user})> login(
      {required String email, required String password}) async {
    final res = await api.login(email: email, password: password, deviceName: 'app');
    final token = (res['access_token'] ?? res['token'] ?? '').toString();
    final tokenType = (res['token_type'] ?? 'Bearer').toString();
    final user = (res['user'] is Map<String, dynamic>)
        ? (res['user'] as Map<String, dynamic>)
        : <String, dynamic>{};
    if (token.isEmpty) {
      throw Exception('Login response missing token');
    }
    return (token: token, tokenType: tokenType, user: user);
  }
}

