import 'package:flutter/foundation.dart';
import 'package:ecommerce/models/cart_item.dart';
import 'package:ecommerce/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get totalCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addProduct(Product product, {int quantity = 1}) {
    final id = product.id;
    if (id.isEmpty) return;
    if (_items.containsKey(id)) {
      _items[id]!.quantity += quantity;
    } else {
      _items[id] = CartItem(
        id: id,
        name: product.name,
        imageUrl: product.imageUrl,
        priceLabel: product.priceLabel,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void addByFields({
    required String id,
    required String name,
    required String imageUrl,
    required String priceLabel,
    int quantity = 1,
  }) {
    if (id.isEmpty) return;
    if (_items.containsKey(id)) {
      _items[id]!.quantity += quantity;
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        imageUrl: imageUrl,
        priceLabel: priceLabel,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void decrement(String id) {
    if (!_items.containsKey(id)) return;
    final item = _items[id]!;
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

