import 'package:ecommerce/views/screens/productDetail.dart';
import 'package:flutter/material.dart';

const Color accent = Color(0xFFD1B464);

class ProductScreen extends StatelessWidget {
  final VoidCallback? onCartTap;
  final int cartCount;

  const ProductScreen({super.key, this.onCartTap, this.cartCount = 0});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _herobanner(context, colorScheme, textTheme),
            const _SectionDivider(),
            _productcard(context, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _herobanner(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.46;

    return Column(
      children: [
        // --- Hero Section ---
        SizedBox(
          height: heroHeight,
          child: Row(
            children: [
              // Left: Main Watch + Text
              Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero_watchproduct.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withOpacity(0.68)),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gc\nTECHNOCLASS',
                            style: textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A statement of Unique Sport-Tech',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.83),
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right: Vertical Tagline
              Expanded(
                flex: 1,
                child: Container(
                  color: colorScheme.surface,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'FIND YOUR PERFECT TIMEPIECE',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // --- Editorial Grid ---
        SizedBox(
          height: 130,
          child: Row(
            children: [
              Expanded(
                child: _EditorialTile(
                  image: 'assets/images/new_arrival.jpg',
                  title: 'NEW ARRIVAL DIVER CHIC PYTHON',
                  subtitle: 'A statement of Classic allure',
                ),
              ),
              Expanded(
                child: _EditorialTile(
                  image: 'assets/images/moments.jpg',
                  title: 'MOMENTS OF SMART LUXURY',
                  subtitle: 'From the Saddle',
                  colorOverlay: Colors.black.withOpacity(0.22),
                ),
              ),
              Expanded(
                child: _EditorialTile(
                  image: 'assets/images/lifestyle.jpg',
                  title: '',
                  subtitle: '',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productcard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final products = [
      {
        "name": "Patek Philippe Nautilus 5711",
        "price": "\$3,200,000.00",
        "image": "assets/images/patek.jpg",
      },
      {
        "name": "Richard Mille RM 11-03",
        "price": "\$2,300,000.00",
        "image": "assets/images/richard.jpg",
      },
      {
        "name": "Vacheron Constantin Overseas",
        "price": "\$1,230,000.00",
        "image": "assets/images/vacheron.jpg",
      },
      {
        "name": "Jaeger-LeCoultre Reverso",
        "price": "\$3,290,000.00",
        "image": "assets/images/jaeger.jpg",
      },
      {
        "name": "Hublot Big Bang Unico",
        "price": "\$238,700.00",
        "image": "assets/images/hublot.jpg",
      },
      {
        "name": "Cartier Santos de Cartier",
        "price": "\$1,276,000.00",
        "image": "assets/images/cartier.jpg",
      },
      {
        "name": "IWC Portugieser Chronograph",
        "price": "\$1,120,000.00",
        "image": "assets/images/iwc.jpg",
      },
      {
        "name": "Panerai Luminor Marina",
        "price": "\$895,000.00",
        "image": "assets/images/panerai.jpg",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title and cart button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                "OUR PRODUCTS",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                  color: colorScheme.onBackground,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onCartTap ?? () {},
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: Text("Cart ($cartCount)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  textStyle: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Product Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 22,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return _ProductCard(
                name: p['name']!,
                price: p['price']!,
                imagePath: p['image']!,
                colorScheme: colorScheme,
                textTheme: textTheme,
              );
            },
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

// --- Gold divider ---
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(
        width: 60,
        height: 3,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFe3c77b), Color(0xFFD1B464), Color(0xFFe3c77b)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// -- EditorialTile with themed overlay --
class _EditorialTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color? colorOverlay;

  const _EditorialTile({
    required this.image,
    required this.title,
    required this.subtitle,
    this.colorOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image, fit: BoxFit.cover),
        if (colorOverlay != null)
          Container(color: colorOverlay)
        else
          Container(color: Colors.black.withOpacity(0.08)),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.05,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w400,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black38)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// -- ProductCard luxury style & fully theme-aware --
class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProductDetailScreen(
                  name: name,
                  price: price,
                  imagePath: imagePath,
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 11,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 90, fit: BoxFit.contain),
              const SizedBox(height: 8),
              Text(
                name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: textTheme.titleMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_outlined, size: 17),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    textStyle: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
