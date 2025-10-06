import 'package:ecommerce/models/product.dart';

class WishlistItem {
  final String productId;
  final String name;
  final String priceLabel;
  final String imageUrl;
  final String description;
  final DateTime addedAt;

  const WishlistItem({
    required this.productId,
    required this.name,
    required this.priceLabel,
    required this.imageUrl,
    required this.description,
    required this.addedAt,
  });

  factory WishlistItem.fromProduct(Product product, {DateTime? at}) {
    return WishlistItem(
      productId: product.id,
      name: product.name,
      priceLabel: product.priceLabel,
      imageUrl: product.imageUrl,
      description: product.description,
      addedAt: at ?? DateTime.now(),
    );
  }

  factory WishlistItem.fromMap(Map<String, Object?> map) {
    return WishlistItem(
      productId: (map['product_id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      priceLabel: (map['price_label'] ?? '').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      addedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['added_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'product_id': productId,
      'name': name,
      'price_label': priceLabel,
      'image_url': imageUrl,
      'description': description,
      'added_at': addedAt.millisecondsSinceEpoch,
    };
  }

  Product toProduct() {
    return Product(
      id: productId,
      name: name,
      priceLabel: priceLabel,
      imageUrl: imageUrl,
      description: description,
    );
  }
}
