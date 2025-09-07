import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductsApi {
  final String baseUrl;
  final String? imageBaseUrl; // e.g., https://your-bucket.s3.ap-south-1.amazonaws.com
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
    List<Product> list;
    if (data is List) {
      list = data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map<String, dynamic> && data['items'] is List) {
      list = (data['items'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      list = (data['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Unexpected products response shape');
    }
    // Normalize image URLs if API returns relative paths
    final origin = '${uri.scheme}://${uri.host}';
    return list
        .map((p) {
          final img = p.imageUrl;
          if (img.isEmpty) return p;
          if (img.startsWith('http')) return p;
          // If S3 base is provided, prefer that. Otherwise, fall back to /storage on the API host.
          final base = imageBaseUrl ?? '$origin/storage';
          final guess = base.endsWith('/') ? '$base$img' : '$base/$img';
          return Product(
            id: p.id,
            name: p.name,
            priceLabel: p.priceLabel,
            imageUrl: guess,
            description: p.description,
          );
        })
        .toList();
  }
}
