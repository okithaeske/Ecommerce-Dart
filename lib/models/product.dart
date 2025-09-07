class Product {
  final String id;
  final String name;
  final String priceLabel;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['product_id'] ?? json['uuid'] ?? '').toString();
    final name = (json['name'] ?? json['title'] ?? 'Product').toString();
    final image = (json['image_url'] ?? json['imageUrl'] ?? json['image'] ?? json['image_path'] ?? json['thumbnail'] ?? '').toString();
    final price = json['price'];
    final desc = (json['description'] ?? '').toString();
    String priceLabel;
    if (price is num) {
      priceLabel = _formatPrice(price.toDouble());
    } else if (price is String) {
      priceLabel = price.trim().startsWith(r'$') ? price : '\$$price';
    } else {
      priceLabel = r'$--';
    }
    return Product(
      id: id,
      name: name,
      priceLabel: priceLabel,
      imageUrl: image,
      description: desc,
    );
  }

  static String _formatPrice(double value) {
    final s = value.toStringAsFixed(2);
    return '\$$s';
  }
}
