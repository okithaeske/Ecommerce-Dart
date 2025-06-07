import 'package:flutter/material.dart';

const Color accent = Color(0xFFD1B464); // Brand gold

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroBanner(context, colorScheme, textTheme),
              const _SectionDivider(),
              _buildFeatureHighlights(colorScheme),
              const _SectionDivider(),
              _buildNewArrivals(context, colorScheme, textTheme),
              const _SectionDivider(),
              _buildPromoSection(colorScheme, textTheme),
              const _SectionDivider(),
              _buildBrandRow(colorScheme, textTheme),
              const _SectionDivider(),
              _buildTestimonials(colorScheme, textTheme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Hero Banner with animation ---
  Widget _buildHeroBanner(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return _AnimatedHeroBanner(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  Widget _buildFeatureHighlights(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _FeatureItem("Extended Warranty"),
          _FeatureItem("Free Shipping"),
          _FeatureItem("Easy 30-Day Returns"),
        ],
      ),
    );
  }

  Widget _buildNewArrivals(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final watches = [
      {"name": "ASTRON", "price": "\$52,000"},
      {"name": "CITIZEN", "price": "\$38,500"},
      {"name": "OMEGA", "price": "\$102,000"},
      {"name": "SEIKO", "price": "\$46,200"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "New Arrivals",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onBackground),
          ),
        ),
        SizedBox(
          height: 220,
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/promo_watch.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Choose a watch that suits who you are.\nWe make it easy for you to find the perfect timepiece.",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandRow(ColorScheme colorScheme, TextTheme textTheme) {
    final brands = ["timex", "gucci", "omega", "tissot", "rolex", "casio"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Brands We Love",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 12,
          children: brands
              .map((brand) => Image.asset('assets/images/$brand.jpg', width: 200, height: 80, fit: BoxFit.contain))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTestimonials(ColorScheme colorScheme, TextTheme textTheme) {
    final reviews = [
      {"name": "Nimasha", "review": "Absolutely love the design and quality!"},
      {"name": "Ramesh", "review": "Elegant and stylish. A perfect gift."},
      {"name": "Tharushi", "review": "Fast shipping and premium build."},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Testimonials",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onBackground),
          ),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: reviews
              .map((rev) => _TestimonialCard(
                    name: rev['name']!,
                    review: rev['review']!,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ))
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
    super.key,
  });

  @override
  State<_AnimatedHeroBanner> createState() => _AnimatedHeroBannerState();
}

class _AnimatedHeroBannerState extends State<_AnimatedHeroBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
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
          color: Colors.black.withOpacity(0.5),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Allow Yourself To\nBe A Step Ahead",
                  style: widget.textTheme.headlineSmall?.copyWith(
                    color: widget.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Discover exceptional watches for every moment.",
                  style: widget.textTheme.bodyMedium?.copyWith(
                    color: widget.colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Shop Now"),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accent,
                        side: const BorderSide(color: accent, width: 1.4),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      label,
      style: textTheme.labelLarge?.copyWith(
        color: accent,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// --- Watch Card ---
class _WatchCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WatchCard({
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
        // Optionally show a dialog or go to details page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preview: $name')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.04),
              blurRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Image.asset(imagePath, height: 120, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              name,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            Text(
              price,
              style: textTheme.bodyMedium?.copyWith(color: accent),
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

  const _TestimonialCard({
    required this.name,
    required this.review,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.watch, size: 40, color: accent),
          const SizedBox(height: 8),
          Text(
            review,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
