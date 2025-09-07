import 'package:ecommerce/utils/theme.dart';
import 'package:ecommerce/utils/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    final watches = [
      {"name": "ASTRON", "price": "\$52,000"},
      {"name": "CITIZEN", "price": "\$38,00"},
      {"name": "OMEGA", "price": "\$102,000"},
      {"name": "SEIKO", "price": "\$46,200"},
    ];

    if (width < 600) {
      // Horizontal list for phones
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
              itemCount: watches.length,
              itemBuilder: (context, index) {
                return _WatchCard(
                  name: watches[index]['name']!,
                  price: watches[index]['price']!,
                  imagePath: 'assets/images/watch${index + 1}.jpg',
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
      // Responsive grid for wide screens/tablets/web
      int columns = (width ~/ 220).clamp(2, 4);
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
                childAspectRatio: 0.8,
              ),
              itemCount: watches.length,
              itemBuilder: (context, index) {
                return _WatchCard(
                  name: watches[index]['name']!,
                  price: watches[index]['price']!,
                  imagePath: 'assets/images/watch${index + 1}.jpg',
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
class _WatchCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final double width;

  const _WatchCard({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.colorScheme,
    required this.textTheme,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Preview: $name')));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: 260, // Set a consistent height for the card
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildHeroImage(imagePath, colorScheme.primary, height: 110),
            const SizedBox(height: 6),
            Text(
              name,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              price,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            const Spacer(), // Pushes button to the bottom
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
