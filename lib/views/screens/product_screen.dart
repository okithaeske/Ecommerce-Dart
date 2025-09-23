// import 'package:ecommerce/utils/widgets.dart';
import 'package:ecommerce/views/screens/product_detail.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/products_api.dart';
import 'package:ecommerce/repositories/products_repository.dart';
import 'package:ecommerce/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/providers/cart_provider.dart';

class ProductScreen extends StatefulWidget {
  final VoidCallback? onCartTap;
  final int cartCount;

  const ProductScreen({super.key, this.onCartTap, this.cartCount = 0});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductsRepository _repo;
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _repo = ProductsRepository(
      ProductsApi(
        baseUrl: 'https://zentara.duckdns.org/api/products',
      ),
    );
    _future = _repo.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Products now fetched from API via repository

    // Device size/landscape logic
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = size.width;

    // Dynamic columns: phone = 2, tab = 3, large = 4, desktop = 5+
    int crossAxisCount = 2;
    if (width > 1350) {
      crossAxisCount = 5;
    } else if (width > 1100) {
      crossAxisCount = 4;
    } else if (width > 700) {
      crossAxisCount = 3;
    }

    // Dynamic product card aspect ratio
    double aspectRatio = isLandscape ? 0.75 : 0.65;
    double gridSpacing = isLandscape ? 32 : 18;

    // Hero height cap
    final heroHeight =
         isLandscape
             ? (size.height * 0.32).clamp(210, 350).toDouble()
             : (size.height * 0.44);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton:
          width > 900
              ? FloatingActionButton.extended(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.black,
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text("Cart (${widget.cartCount})"),
                onPressed: widget.onCartTap ?? () {},
              )
              : null,
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load products'));
          }
          final items = snapshot.data ?? const <Product>[];
          return CustomScrollView(
          slivers: [
          SliverToBoxAdapter(
            child: _herobanner(context, colorScheme, textTheme, heroHeight),
          ),
          SliverToBoxAdapter(child: const _SectionDivider()),
          // Section Title & Cart Button (hide FAB on large screens)
          if (width <= 900)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      "OUR PRODUCTS",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: widget.onCartTap ?? () {},
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: Text("Cart (${widget.cartCount})"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
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
            ),
          // Responsive Product Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: gridSpacing, vertical: 0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing + 8,
                childAspectRatio: aspectRatio,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final p = items[index];
                return _ProductCard(
                  product: p,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                );
              }, childCount: items.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      );
        },
      ),
    );
  }

  // ---- Hero Banner + Editorial Tiles ----
  Widget _herobanner(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double heroHeight,
  ) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        // --- Hero Section ---
        SizedBox(
          height: heroHeight,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero_watchproduct.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.68)),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gc\nTECHNOCLASS',
                            style: textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A statement of Unique Sport-Tech',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.83),
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
              if (!isLandscape) ...[
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
            ],
          ),
        ),
        // --- Editorial Grid ---
        SizedBox(
          height: 120,
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
                  colorOverlay: Colors.black.withValues(alpha: 0.22),
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
          Container(color: Colors.black.withValues(alpha: 0.08)),
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
  final Product product;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProductCard({
    required this.product,
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
            builder: (_) => ProductDetailScreen(
              id: product.id,
              name: product.name,
              price: product.priceLabel,
              imagePath: product.imageUrl,
              description: product.description,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 7,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          height: 240, // You can make this dynamic if needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Hero(
                        tag: product.imageUrl,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.07),
                                blurRadius: 13,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: product.imageUrl.startsWith('http')
                                ? Image.network(
                                    product.imageUrl,
                                    height: 82,
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      height: 82,
                                      width: 82,
                                      color: Colors.black12,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image, size: 22),
                                    ),
                                  )
                                : Image.asset(product.imageUrl, height: 82, fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
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
                      product.priceLabel,
                      style: textTheme.titleMedium?.copyWith(
                         color: colorScheme.primary,
                         fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final online = context.read<ConnectivityService>().isOnline;
                    if (!online) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Offline: cannot add to cart')),
                      );
                      return;
                    }
                    context.read<CartProvider>().addProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart!')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, size: 17),
                  label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
