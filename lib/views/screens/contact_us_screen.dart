import 'package:flutter/material.dart';

// Accent color for your brand (premium gold)
const Color accent = Color(0xFFD1B464);

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
      ),
    );
  }
}

// --- Hero Banner Section ---
class ContactHeroBanner extends StatelessWidget {
  const ContactHeroBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 210,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            image: const DecorationImage(
              image: AssetImage('assets/images/hero_watchContact.jpg'), // Your hero image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 24,
          bottom: 22,
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
      ],
    );
  }
}

// --- Contact Form Section ---
class ContactFormCard extends StatelessWidget {
  const ContactFormCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("We're Always Here To Assist",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text("Leave us a message and our team will get back to you soon.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              // Name
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              // Email
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              // Message
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              // Checkbox & Button
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v) {}),
                  Expanded(child: Text("I agree with terms & conditions")),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text("Send Message", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Section Divider ---
class ContactSectionDivider extends StatelessWidget {
  const ContactSectionDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Divider(thickness: 1.5, color: Colors.grey[300]),
    );
  }
}

// --- Contact Details Section ---
class ContactDetailsSection extends StatelessWidget {
  const ContactDetailsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: accent),
              const SizedBox(width: 10),
              Expanded(child: Text("123 Zenatara Avenue, Kandy, Sri Lanka")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: accent),
              const SizedBox(width: 10),
              Expanded(child: Text("+94 77 123 4567")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.mail_outline, color: accent),
              const SizedBox(width: 10),
              Expanded(child: Text("support@zenatara.com")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, color: accent),
              const SizedBox(width: 10),
              Expanded(child: Text("Mon–Fri: 9:00–18:00 | Sat: 10:00–14:00")),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Shop Locations Section ---
class ShopLocationsSection extends StatelessWidget {
  const ShopLocationsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Shop Locations", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accent)),
          const SizedBox(height: 8),
          Card(
            color: Colors.grey.shade100,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.place, color: accent),
                  const SizedBox(width: 8),
                  Text("Colombo | Kandy | Galle", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Map Preview Section ---
class MapPreviewSection extends StatelessWidget {
  const MapPreviewSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/preview_map.png', // Use your own map preview
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// --- Newsletter / Footer Section (Optional) ---
class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        children: [
          Text(
            "Subscribe to our newsletter for updates & offers!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                ),
                child: Text("Subscribe"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
