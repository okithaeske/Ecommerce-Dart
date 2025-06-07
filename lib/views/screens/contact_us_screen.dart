import 'package:flutter/material.dart';

const Color accent = Color(0xFFD1B464); // Brand gold

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: _ResponsiveBody(), // Responsive wrapper
      ),
    );
  }
}

// --- Responsive switcher: column for mobile, row for landscape/tablet ---
class _ResponsiveBody extends StatelessWidget {
  const _ResponsiveBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final width = MediaQuery.of(context).size.width;

    if (isLandscape && width > 800) {
      // Tablet/Landscape/Web
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Hero + Form + Newsletter
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ContactHeroBanner(),
                  ContactFormCard(),
                  NewsletterSection(),
                ],
              ),
            ),
            const SizedBox(width: 36),
            // Right: Details/Locations/Map
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ContactSectionDivider(),
                  ContactDetailsSection(),
                  ShopLocationsSection(),
                  MapPreviewSection(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile/Portrait
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ContactHeroBanner(),
            ContactFormCard(),
            ContactSectionDivider(),
            ContactDetailsSection(),
            ShopLocationsSection(),
            MapPreviewSection(),
            NewsletterSection(),
          ],
        ),
      );
    }
  }
}

// --- Hero Banner Section with slight fade-in animation ---
class ContactHeroBanner extends StatefulWidget {
  const ContactHeroBanner({super.key});
  @override
  State<ContactHeroBanner> createState() => _ContactHeroBannerState();
}
class _ContactHeroBannerState extends State<ContactHeroBanner> with SingleTickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: "Contact Us hero banner with luxury watch background",
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              image: const DecorationImage(
                image: AssetImage('assets/images/hero_watchContact.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 22,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: accent,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black12)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Contact Form Section with state for the checkbox ---
class ContactFormCard extends StatefulWidget {
  const ContactFormCard({super.key});
  @override
  State<ContactFormCard> createState() => _ContactFormCardState();
}
class _ContactFormCardState extends State<ContactFormCard> {
  bool _agreed = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Card(
        elevation: 5,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We're Always Here To Assist",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Leave us a message and our team will get back to you soon.",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Name",
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Email",
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Message",
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    activeColor: accent,
                    side: BorderSide(color: accent),
                  ),
                  Expanded(
                    child: Text(
                      "I agree with terms & conditions",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _agreed
                      ? () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message sent!'), duration: Duration(seconds: 2)),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: accent.withOpacity(0.45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  child: const Text("Send Message"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Section Divider with gold accent ---
class ContactSectionDivider extends StatelessWidget {
  const ContactSectionDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Container(
        width: 48,
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

// --- Contact Details Section ---
class ContactDetailsSection extends StatelessWidget {
  const ContactDetailsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          _iconRow(context, Icons.location_on_outlined, "123 Zenatara Avenue, Kandy, Sri Lanka"),
          const SizedBox(height: 10),
          _iconRow(context, Icons.phone, "+94 77 123 4567"),
          const SizedBox(height: 10),
          _iconRow(context, Icons.mail_outline, "support@zenatara.com"),
          const SizedBox(height: 10),
          _iconRow(context, Icons.access_time, "Mon–Fri: 9:00–18:00 | Sat: 10:00–14:00"),
        ],
      ),
    );
  }
  Widget _iconRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: accent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

// --- Shop Locations Section ---
class ShopLocationsSection extends StatelessWidget {
  const ShopLocationsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shop Locations",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accent),
          ),
          const SizedBox(height: 8),
          Card(
            color: colorScheme.surfaceVariant,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.place, color: accent),
                  const SizedBox(width: 8),
                  Text(
                    "Colombo | Kandy | Galle",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Map Preview Section with semantics for accessibility ---
class MapPreviewSection extends StatelessWidget {
  const MapPreviewSection({super.key});
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Semantics(
      label: "Preview of our shop locations on a map",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/preview_map.png',
            height: isLandscape ? 180 : 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// --- Newsletter / Footer Section ---
class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        children: [
          Text(
            "Subscribe to our newsletter for updates & offers!",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscribed!'), duration: Duration(seconds: 2)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                ),
                child: const Text("Subscribe"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
