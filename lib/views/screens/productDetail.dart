import 'package:flutter/material.dart';

const Color accent = Color(0xFFD1B464); // Brand Gold

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Product Image with luxury border effect
            Center(
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
            const SizedBox(height: 20),
            // -- Gold divider
            Center(
              child: Container(
                width: 56,
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFe3c77b), accent, Color(0xFFe3c77b)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // -- Price
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
            // -- Details Section Card
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
            // -- Add to Cart Button
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
        ),
      ),
    );
  }
}
