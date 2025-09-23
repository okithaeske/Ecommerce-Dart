import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce/models/product.dart';

class SemanticSearchService {
  static const String _endpoint = String.fromEnvironment('SEMANTIC_SEARCH_URL');

  static bool get enabled => _endpoint.isNotEmpty;

  static final SemanticSearchService instance = SemanticSearchService._();
  SemanticSearchService._();

  Future<List<Product>?> reorder(List<Product> items, String query) async {
    if (!enabled || items.isEmpty) return null;
    try {
      final payload = {
        'query': query,
        'items': items
            .map((p) => {
                  'id': p.id,
                  'name': p.name,
                  'description': p.description,
                })
            .toList(),
      };
      final res = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(payload),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        // Support either { order: [ids...] } or { scores: [{id, score}] }
        if (body is Map<String, dynamic>) {
          if (body['order'] is List) {
            final order = (body['order'] as List).map((e) => e.toString()).toList();
            final map = {for (final p in items) p.id: p};
            final reordered = <Product>[
              ...order.where(map.containsKey).map((id) => map[id]!),
              ...items.where((p) => !order.contains(p.id)),
            ];
            return reordered;
          }
          if (body['scores'] is List) {
            final scores = <String, double>{};
            for (final s in (body['scores'] as List)) {
              if (s is Map<String, dynamic>) {
                final id = s['id']?.toString();
                final sc = (s['score'] is num) ? (s['score'] as num).toDouble() : null;
                if (id != null && sc != null) scores[id] = sc;
              }
            }
            final withScores = items.map((p) => (p, scores[p.id] ?? 0.0)).toList();
            withScores.sort((a, b) => b.$2.compareTo(a.$2));
            return withScores.map((e) => e.$1).toList();
          }
        }
      }
    } catch (_) {
      // ignore network errors and fall back
    }
    return null;
  }
}

