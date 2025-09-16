class CartItem {
  final String id; // product id
  final String name;
  final String imageUrl;
  final String priceLabel; // e.g. "$8200.00"
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.priceLabel,
    this.quantity = 1,
  });

  double get unitPrice {
    final cleaned = priceLabel.replaceAll(RegExp(r"[^0-9\.]"), "");
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get totalPrice => unitPrice * quantity;
}

