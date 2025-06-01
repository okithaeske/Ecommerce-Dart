import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final VoidCallback? onCartTap;
  final int cartCount;

  const ProductScreen({super.key, this.onCartTap, this.cartCount = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _herobanner(context),
            _productcard(context),
          ],
        ),
      ),
    );
  }

  Widget _herobanner(BuildContext context) {
    // Responsive height for hero section
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.46; // About 46% of the screen height

    return Column(
      children: [
        // --- Top Row: Large Watch + Text, and Vertical Title ---
        SizedBox(
          height: heroHeight,
          child: Row(
            children: [
              // Left: Large Watch & Headline (2/3 width)
              Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // BG Image
                    Image.asset(
                      'assets/images/hero_watchproduct.jpg', // Your main watch image
                      fit: BoxFit.cover,
                    ),
                    // Dark overlay
                    Container(color: Colors.black.withOpacity(0.7)),
                    // Text Overlay
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Gc\nTECHNOCLASS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26, // Slightly smaller for mobile
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              height: 1.12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'A statement of Unique Sport-Tech',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 1.2,
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
              // Right: Vertical Text (1/3 width)
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: RotatedBox(
                      quarterTurns: 3, // Vertical
                      child: Text(
                        'FIND YOUR PERFECT TIMEPIECE',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
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

        // --- Bottom Row: Editorial Grid ---
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
                  colorOverlay: Colors.black.withOpacity(0.25),
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

  Widget _productcard(BuildContext context) {
    // Example product list
    final products = [
      {
        "name": "Patek Philippe Nautilus 5711",
        "price": "\$3,200,000.00",
        "image": "assets/images/patek.jpg"
      },
      {
        "name": "Richard Mille RM 11-03",
        "price": "\$2,300,000.00",
        "image": "assets/images/richard.jpg"
      },
      {
        "name": "Vacheron Constantin Overseas",
        "price": "\$1,230,000.00",
        "image": "assets/images/vacheron.jpg"
      },
      {
        "name": "Jaeger-LeCoultre Reverso",
        "price": "\$3,290,000.00",
        "image": "assets/images/jaeger.jpg"
      },
      {
        "name": "Hublot Big Bang Unico",
        "price": "\$238,700.00",
        "image": "assets/images/hublot.jpg"
      },
      {
        "name": "Cartier Santos de Cartier",
        "price": "\$1,276,000.00",
        "image": "assets/images/cartier.jpg"
      },
      {
        "name": "IWC Portugieser Chronograph",
        "price": "\$1,120,000.00",
        "image": "assets/images/iwc.jpg"
      },
      {
        "name": "Panerai Luminor Marina",
        "price": "\$895,000.00",
        "image": "assets/images/panerai.jpg"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Section Title and Cart Button ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Text(
                "OUR PRODUCTS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.2,
                  color: Color(0xFF17294D), // Deep navy
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onCartTap ?? () {},
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: Text("Cart ($cartCount)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        // --- Product Grid ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 18,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return _ProductCard(
                name: p['name']!,
                price: p['price']!,
                imagePath: p['image']!,
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

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

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
