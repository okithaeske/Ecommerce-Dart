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

  // Simple mapping tailored to zentara API
  factory Product.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();
    final name = (json['name'] ?? 'Product').toString();
    final image = (json['image_url'] ?? json['image_path'] ?? '').toString();
    final price = json['price'];
    final desc = (json['description'] ?? '').toString();
    String priceLabel;
    if (price is num) {
      priceLabel = _formatPrice(price.toDouble());
    } else if (price is String && price.isNotEmpty) {
      // API returns e.g. "8200.00"; prefix with '$' if not present
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price_label': priceLabel,
        'image_url': imageUrl,
        'description': description,
      };
}
