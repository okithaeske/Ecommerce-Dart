import 'package:flutter/material.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/products_api.dart';
import 'package:ecommerce/repositories/products_repository.dart';
import 'product_detail.dart';
import 'package:ecommerce/utils/fuzzy.dart';
import 'package:ecommerce/utils/nlu.dart';
import 'package:ecommerce/services/semantic_search_service.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final ProductsRepository _repo;
  late Future<List<Product>> _future;
  late final List<String> _queryTokens;
  late final ParsedQuery _parsed;
  late Future<List<Product>> _results;

  @override
  void initState() {
    super.initState();
    _repo = ProductsRepository(ProductsApi(baseUrl: 'https://zentara.duckdns.org/api/products'));
    _future = _repo.getProducts();
    _queryTokens = _tokens(widget.query);
    _parsed = parseQuery(widget.query, LexiconService.instance.config);
    _results = _future.then((all) async {
      final filtered = _filter(all, widget.query);
      final semantic = await SemanticSearchService.instance.reorder(filtered, widget.query);
      return semantic ?? filtered;
    });
  }

  List<Product> _filter(List<Product> items, String q) {
    final query = q.trim();
    if (query.isEmpty) return const <Product>[];

    final priceRange = (_parsed.minPrice, _parsed.maxPrice);
    final threshold = 0.30; // accept close matches / minor typos

    final scored = <(Product, double)>[];
    for (final p in items) {
      // Price filter if present
      if (priceRange != null) {
        final price = _parsePrice(p.priceLabel);
        if (price == null) continue;
        final minOk = priceRange.$1 == null || price >= priceRange.$1!;
        final maxOk = priceRange.$2 == null || price <= priceRange.$2!;
        if (!(minOk && maxOk)) continue;
      }

      // Base fuzzy score on raw query
      double s = scoreProduct(name: p.name, description: p.description, query: query);

      // Facet weighting
      final nameLower = p.name.toLowerCase();
      final descLower = p.description.toLowerCase();
      // Brand weight
      for (final b in _parsed.brands) {
        if (nameLower.contains(b)) s += 0.12;
        else if (descLower.contains(b)) s += 0.06;
      }
      // Type weight
      for (final t in _parsed.types) {
        if (nameLower.contains(t)) s += 0.10;
        else if (descLower.contains(t)) s += 0.05;
      }
      // Color/material/strap light weights
      for (final c in _parsed.colors) {
        if (nameLower.contains(c) || descLower.contains(c)) s += 0.03;
      }
      for (final m in _parsed.materials) {
        if (nameLower.contains(m) || descLower.contains(m)) s += 0.03;
      }
      for (final st in _parsed.straps) {
        if (nameLower.contains(st) || descLower.contains(st)) s += 0.03;
      }

      if (s >= threshold) scored.add((p, s.clamp(0.0, 1.0)));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }

  List<String> _suggestBrands(String query, List<Product> items, {int max = 5}) {
    final lex = LexiconService.instance.config;
    final tokens = _tokens(query);
    final candidates = <(String, double)>[];
    for (final b in lex.brands) {
      double s = 0;
      for (final t in tokens) {
        final d = 1.0 - (scoreTextMatch(text: b, query: t));
        s = s < d ? d : s;
      }
      // use similarity directly
      final sim = tokens.map((t) => scoreTextMatch(text: b, query: t)).fold<double>(0, (a, v) => a + v) / (tokens.isEmpty ? 1 : tokens.length);
      candidates.add((b, sim));
    }
    candidates.sort((a, b) => b.$2.compareTo(a.$2));
    return candidates.take(max).map((e) => e.$1).toList();
  }

  String _injectOrReplaceBrand(String query, String brand) {
    final tokens = _tokens(query);
    final lex = LexiconService.instance.config;
    // Replace any alias/brand token with suggested brand
    final out = <String>[];
    bool replaced = false;
    for (final t in tokens) {
      if (!replaced && (lex.brands.contains(t) || lex.brandAliases.containsKey(t))) {
        out.add(brand);
        replaced = true;
      } else {
        out.add(t);
      }
    }
    if (!replaced) out.add(brand);
    return out.join(' ');
  }

  double? _parsePrice(String priceLabel) {
    // Extract a numeric value from a label like "$8,200.00"
    final s = priceLabel.replaceAll(RegExp(r"[^0-9\.]"), "");
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  List<String> _tokens(String s) => s
      .toLowerCase()
      .split(RegExp(r"[^a-z0-9]+"))
      .where((t) => t.isNotEmpty)
      .toList();

  InlineSpan _highlight(String text) {
    if (_queryTokens.isEmpty) return TextSpan(text: text);
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    int i = 0;
    while (i < text.length) {
      int matchStart = -1;
      String? matchToken;
      for (final t in _queryTokens) {
        final idx = lower.indexOf(t, i);
        if (idx == i && t.isNotEmpty) {
          matchStart = idx;
          matchToken = t;
          break;
        }
      }
      if (matchStart == i && matchToken != null) {
        spans.add(TextSpan(text: text.substring(i, i + matchToken.length), style: const TextStyle(fontWeight: FontWeight.w600)));
        i += matchToken.length;
      } else {
        spans.add(TextSpan(text: text[i]));
        i += 1;
      }
    }
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Results: "${widget.query}"'),
        backgroundColor: cs.surface,
      ),
      body: FutureBuilder<List<Product>>(
        future: _results,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Failed to load products', style: tt.bodyMedium?.copyWith(color: cs.error)),
            );
          }
          final items = snapshot.data ?? const <Product>[];

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length + (items.length < 3 ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == 0 && items.length < 3) {
                // Clarification chips section when results are sparse
                final suggestions = _suggestBrands(widget.query, all, max: 5);
                if (suggestions.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: suggestions.map((s) => ActionChip(
                      label: Text(s),
                      onPressed: () {
                        final q = _injectOrReplaceBrand(widget.query, s);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SearchResultsScreen(query: q)),
                        );
                      },
                    )).toList(),
                  ),
                );
              }
              final p = items[index - (items.length < 3 ? 1 : 0)];
              return Material(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          id: p.id,
                          name: p.name,
                          price: p.priceLabel,
                          imagePath: p.imageUrl,
                          description: p.description,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _ProductThumb(url: p.imageUrl),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                _highlight(p.name),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface),
                              ),
                              const SizedBox(height: 4),
                              Text.rich(
                                _highlight(p.description),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(p.priceLabel, style: tt.labelLarge?.copyWith(color: cs.primary)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  final String url;
  const _ProductThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    final size = 64.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: size,
        width: size,
        color: Colors.black12,
        alignment: Alignment.center,
        child: url.startsWith('http')
            ? Image.network(
                url,
                height: size,
                width: size,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
              )
            : Image.asset(url, height: size, width: size, fit: BoxFit.contain),
      ),
    );
  }
}
