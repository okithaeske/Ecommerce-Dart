import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import 'local_json_store.dart';

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

    // Check connectivity first
    final connectivity = await Connectivity().checkConnectivity();
    final online = connectivity.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);

    final cacheBox = Hive.box('cache');
    const cacheKey = 'products_raw';

    if (!online) {
      // Prefer readable local JSON file first
      final fileProducts = await LocalJsonStore.readProductsIfExists();
      if (fileProducts != null && fileProducts.isNotEmpty) {
        return fileProducts;
      }
      // Fallback to Hive raw cache
      final cached = cacheBox.get(cacheKey) as String?;
      if (cached != null && cached.isNotEmpty) {
        return _parseProducts(cached);
      }
      // No cache to serve
      throw Exception('No internet connection and no cached products');
    }

    try {
      final res = await _client.get(uri, headers: {'Accept': 'application/json'});
      if (res.statusCode < 200 || res.statusCode >= 300) {
        // On failure, try cache fallback
        final cached = cacheBox.get(cacheKey) as String?;
        if (cached != null && cached.isNotEmpty) {
          return _parseProducts(cached);
        }
        throw Exception('Failed to load products: ${res.statusCode}');
      }
      // Save raw response to cache for offline usage
      await cacheBox.put(cacheKey, res.body);
      final products = _parseProducts(res.body);
      // Also persist a human-readable JSON snapshot atomically
      await LocalJsonStore.writeProducts(products);
      return products;
    } catch (_) {
      // On error, try file snapshot then Hive cache
      final fileProducts = await LocalJsonStore.readProductsIfExists();
      if (fileProducts != null && fileProducts.isNotEmpty) return fileProducts;
      final cached = cacheBox.get(cacheKey) as String?;
      if (cached != null && cached.isNotEmpty) return _parseProducts(cached);
      rethrow;
    }
  }

  List<Product> _parseProducts(String body) {
    final data = jsonDecode(body);
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
