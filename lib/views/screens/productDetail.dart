import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name, price, imagePath;
  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
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
            border: Border.all(color: accent.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.07),
                blurRadius: 13,
                spreadRadius: 1,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(imagePath, height: 210),
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
          shadowColor: accent.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Discover the craftsmanship and elegance of this timepiece. "
              "Perfect for both formal and casual wear. Comes with a 2-year warranty.",
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart!')),
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: colorScheme.background,
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
