import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductsApi {
  final String baseUrl;
  final String? imageBaseUrl;
  final http.Client _client;


  ProductsApi({
    required this.baseUrl,
    this.imageBaseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts({int page = 1, int limit = 20}) async {
    final uri = baseUrl.endsWith('/products')
        ? Uri.parse(baseUrl)
        : Uri.parse('$baseUrl/products');
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load products: ${res.statusCode}');
    }
    final data = jsonDecode(res.body);
    if (data is List) {
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Unexpected products response shape');
  }
}
