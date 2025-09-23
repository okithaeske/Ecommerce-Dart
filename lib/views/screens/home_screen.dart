import 'package:ecommerce/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/services/connectivity_service.dart';
// import 'package:ecommerce/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/products_api.dart';
import 'package:ecommerce/repositories/products_repository.dart';
import 'package:ecommerce/views/screens/product_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductsRepository _repo;
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _repo = ProductsRepository(ProductsApi(baseUrl: 'https://zentara.duckdns.org/api/products'));
    _future = _repo.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final isOnline = context.watch<ConnectivityService>().isOnline;
    

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOnline)
                Container(
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline mode: Showing last saved products',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
                        ),
                      )
                    ],
                  ),
                ),
              _AnimatedHeroBanner(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const _SectionDivider(),
              _buildFeatureHighlights(colorScheme, width),
              const _SectionDivider(),
              _buildNewArrivals(context, colorScheme, textTheme, width),
              const _SectionDivider(),
              _buildPromoSection(context, colorScheme, textTheme, width),
              const _SectionDivider(),
              _buildBrandRow(colorScheme, textTheme, width),
              const _SectionDivider(),
              _buildTestimonials(colorScheme, textTheme, width),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights(ColorScheme colorScheme, double width) {
    final items = const [
      _FeatureItem("Extended Warranty"),
      _FeatureItem("Free Shipping"),
      _FeatureItem("Easy 30-Day Returns"),
    ];

    if (width < 420) {
      // Stack in column for narrow screens
      return Container(
        color: colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Center(child: item),
                    ),
                  )
                  .toList(),
        ),
      );
    }
    // Row for normal/tablet
    return Container(
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Widget _buildNewArrivals(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double width,
  ) {
    final isNarrow = width < 600;
    return FutureBuilder<List<Product>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load products', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
          );
        }
        final items = (snapshot.data ?? const <Product>[]).take(6).toList();
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "New Arrivals",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _NewArrivalCard(
                      product: items[index],
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      width: 140,
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          final columns = (width ~/ 220).clamp(2, 4);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "New Arrivals",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    // Slightly taller cards to avoid vertical overflow
                    childAspectRatio: 0.72,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _NewArrivalCard(
                      product: items[index],
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      width: width / columns - 28,
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPromoSection(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double width,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final promoTextColor = customColors?.promoTextColor ?? Colors.white;
    return Container(
      height: width < 500 ? 120 : 180,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/promo_watch.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        padding: EdgeInsets.all(width < 400 ? 14 : 24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Choose a watch that suits who you are.\nWe make it easy for you to find the perfect timepiece.",
            style: textTheme.titleMedium?.copyWith(color: promoTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandRow(
    ColorScheme colorScheme,
    TextTheme textTheme,
    double width,
  ) {
    final brands = ["timex", "gucci", "omega", "tissot", "rolex", "casio"];
    double imageWidth = width < 450 ? 110 : (width < 700 ? 140 : 200);
    double imageHeight = width < 450 ? 40 : (width < 700 ? 60 : 80);

    if (width < 600) {
      // For phones: wrap logos in grid/wrap layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Brands We Love",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children:
                brands
                    .map(
                      (brand) => Image.asset(
                        'assets/images/$brand.jpg',
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.contain,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      // For wide/tablet/web: horizontal scroll row!
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Brands We Love",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(
            height: imageHeight + 20,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 28),
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Image.asset(
                  'assets/images/$brand.jpg',
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }
  }

  Widget _buildTestimonials(
    ColorScheme colorScheme,
    TextTheme textTheme,
    double width,
  ) {
    final reviews = [
      {"name": "Nimasha", "review": "Absolutely love the design and quality!"},
      {"name": "Ramesh", "review": "Elegant and stylish. A perfect gift."},
      {"name": "Tharushi", "review": "Fast shipping and premium build."},
    ];
    if (width < 600) {
      // Stack vertically for mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Testimonials",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          ...reviews.map(
            (rev) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
              child: _TestimonialCard(
                name: rev['name']!,
                review: rev['review']!,
                colorScheme: colorScheme,
                textTheme: textTheme,
                width: width - 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    // Wrap for tablet/web
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Testimonials",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              reviews
                  .map(
                    (rev) => _TestimonialCard(
                      name: rev['name']!,
                      review: rev['review']!,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      width: width / 3 - 32,
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// --- Gold gradient divider for luxury feel ---
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
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

// --- Hero Banner with fade-in animation ---
class _AnimatedHeroBanner extends StatefulWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _AnimatedHeroBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<_AnimatedHeroBanner> createState() => _AnimatedHeroBannerState();
}

class _AnimatedHeroBannerState extends State<_AnimatedHeroBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final heroTextColor = customColors?.promoTextColor ?? Colors.white;
    return Semantics(
      label: "Hero banner with luxury watch background",
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hero_watch.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.black.withValues(alpha: 0.5),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Allow Yourself To\nBe A Step Ahead",
                  style: widget.textTheme.headlineSmall?.copyWith(
                    color: heroTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Discover exceptional watches for every moment.",
                  style: widget.textTheme.bodyMedium?.copyWith(
                    color: heroTextColor.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Shop Now"),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.4),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Learn More"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Feature Item (highlights) ---
class _FeatureItem extends StatelessWidget {
  final String label;

  const _FeatureItem(this.label);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      label,
      style: textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// --- Watch Card (responsive width) ---
class _NewArrivalCard extends StatelessWidget {
  final Product product;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final double width;

  const _NewArrivalCard({
    required this.product,
    required this.colorScheme,
    required this.textTheme,
    required this.width,
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final imageH = w <= 150 ? 95.0 : 110.0;
            return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                            height: imageH,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: imageH,
                              width: imageH,
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 22),
                            ),
                          )
                        : Image.asset(product.imageUrl, height: imageH, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.priceLabel,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            const Spacer(), // keep button anchored at bottom when space allows
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.black,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Shop Now'),
              ),
            ),
          ],
            );
          },
        ),
      ),
    );
  }
}

// --- Testimonial Card with accent icons ---
class _TestimonialCard extends StatelessWidget {
  final String name;
  final String review;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final double width;

  const _TestimonialCard({
    required this.name,
    required this.review,
    required this.colorScheme,
    required this.textTheme,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.watch, size: 40, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            review,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
