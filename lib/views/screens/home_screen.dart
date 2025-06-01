import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            _buildFeatureHighlights(),
            _buildNewArrivals(),
            _buildPromoSection(),
            _buildBrandRow(),
            _buildTestimonials(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Allow Yourself To\nBe A Step Ahead",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Discover exceptional watches for every moment.",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(onPressed: null, child: Text("Shop Now")),
                SizedBox(width: 8),
                OutlinedButton(onPressed: null, child: Text("Learn More")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    return Container(
      color: Colors.black,
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

  Widget _buildNewArrivals() {
    final watches = [
      {"name": "ASTRON", "price": "LKR 52,000"},
      {"name": "CITIZEN", "price": "LKR 38,500"},
      {"name": "OMEGA", "price": "LKR 102,000"},
      {"name": "SEIKO", "price": "LKR 46,200"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("New Arrivals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
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
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Choose a watch that suits who you are.\nWe make it easy for you to find the perfect timepiece.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandRow() {
    final brands = ["timex", "gucci", "omega", "tissot", "rolex", "casio"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Brands We Love", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          alignment: WrapAlignment.center,
  
          runSpacing: 12,
          children: brands
              .map((brand) => Image.asset('assets/images/$brand.jpg', width: 200, height: 80))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTestimonials() {
    final reviews = [
      {"name": "Nimasha", "review": "Absolutely love the design and quality!"},
      {"name": "Ramesh", "review": "Elegant and stylish. A perfect gift."},
      {"name": "Tharushi", "review": "Fast shipping and premium build."},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Testimonials", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: reviews
              .map((rev) => _TestimonialCard(name: rev['name']!, review: rev['review']!))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String label;

  const _FeatureItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }
}

class _WatchCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;

  const _WatchCard({required this.name, required this.price, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.asset(imagePath, height: 120, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String review;

  const _TestimonialCard({required this.name, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.watch, size: 40, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(review, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
