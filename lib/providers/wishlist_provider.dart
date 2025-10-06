import 'package:flutter/foundation.dart';

import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/wishlist_item.dart';
import 'package:ecommerce/services/wishlist_database.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistProvider({WishlistDatabase? database})
    : _database = database ?? WishlistDatabase.instance {
    _load();
  }

  final WishlistDatabase _database;
  final Map<String, WishlistItem> _items = {};
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<WishlistItem> get items =>
      _items.values.toList()..sort((a, b) => b.addedAt.compareTo(a.addedAt));

  bool isWishlisted(String productId) {
    return _items.containsKey(productId);
  }

  Future<void> _load() async {
    try {
      final rows = await _database.fetchItems();
      _items
        ..clear()
        ..addEntries(rows.map((item) => MapEntry(item.productId, item)));
    } catch (_) {
      // Ignore read errors and surface empty-state UI; callers can retry via operations.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggle(Product product) async {
    if (product.id.isEmpty) {
      return false;
    }
    if (isWishlisted(product.id)) {
      await remove(product.id);
      return false;
    } else {
      await add(product);
      return true;
    }
  }

  Future<void> add(Product product) async {
    final entry = WishlistItem.fromProduct(product);
    await _database.upsert(entry);
    _items[product.id] = entry;
    notifyListeners();
  }

  Future<void> remove(String productId) async {
    await _database.remove(productId);
    final removed = _items.remove(productId);
    if (removed != null) {
      notifyListeners();
    }
  }

  Future<void> clear() async {
    await _database.clear();
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }
}
