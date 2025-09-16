import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String id, name, price, imagePath, description;
  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = colorScheme.primary;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final padding = isLandscape
        ? const EdgeInsets.symmetric(horizontal: 40, vertical: 24)
        : const EdgeInsets.all(20);

    Widget imageWidget = Center(
      child: Hero(
        tag: imagePath,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accent.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.07),
                blurRadius: 13,
                spreadRadius: 1,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    height: 210,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 210,
                      width: 210,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  )
                : Image.asset(imagePath, height: 210),
          ),
        ),
      ),
    );

    Widget infoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 56,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFe3c77b), accent, const Color(0xFFe3c77b)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          price,
          style: textTheme.titleLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          color: colorScheme.surface,
          elevation: 4,
          shadowColor: accent.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description.isNotEmpty
                  ? description
                  : 'No description available.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 15.5,
                height: 1.35,
              ),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              final p = Product(
                id: id,
                name: name,
                priceLabel: price,
                imageUrl: imagePath,
                description: description,
              );
              context.read<CartProvider>().addProduct(p);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart!')),
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: accent),
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: accent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to wishlist!')),
              );
            },
            tooltip: "Add to Wishlist",
          ),
        ],
      ),
      body: Padding(
        padding: padding,
        child: isLandscape
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image left
                  Expanded(child: Align(alignment: Alignment.topCenter, child: imageWidget)),
                  const SizedBox(width: 36),
                  // Info right
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 370,
                      child: infoSection,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  const SizedBox(height: 20),
                  Expanded(child: infoSection),
                ],
              ),
      ),
    );
  }
}
