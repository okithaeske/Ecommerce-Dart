import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double heroHeight =
        screenWidth * 0.9; // Makes the hero banner responsive

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context, heroHeight),
            _buildSectionDivider(),
            _buildQuoteSection(),
            _buildSectionDivider(),
            _buildBrandStory(context),
            _buildSectionDivider(),
            _buildAboutContent(context),
            _buildSectionDivider(),
            _buildTeamSection(context, screenWidth),
            _buildSectionDivider(),
            _buildMissionVisionSection(context),
            _buildSectionDivider(),
            _buildContactInfo(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, double heroHeight) {
    return Stack(
      children: [
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Image.asset('assets/images/hero_watch.jpg', fit: BoxFit.cover),
        ),
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ZENTARA",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Crafting Time. Defining Legacy.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDivider() {
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

  Widget _buildQuoteSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "\"Time is not just measured in seconds, but in the moments we cherish.\"",
          style: const TextStyle(
            color: Color(0xFFE3C77B),
            fontSize: 15,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBrandStory(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // If the screen is small, stack vertically. Otherwise, use Row.
    bool isNarrow = screenWidth < 500; // You can adjust this threshold

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/watchmaking.jpg',
        height: isNarrow ? 200 : 170,
        width: isNarrow ? double.infinity : 120,
        fit: BoxFit.cover,
      ),
    );

    final textWidget = const Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 6),
        child: Text(
          "Founded in the heart of Colombo, Zentara was born out of a passion for precision and a vision to redefine modern luxury. Each piece we craft tells a tale of heritage, innovation, and artistry — where tradition meets timeless beauty.",
          style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Our Story",
            style: TextStyle(
              color: Color(0xFFD1B464),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          isNarrow
              // On narrow screens, stack image above text
              ? Column(
                children: [
                  imageWidget,
                  const SizedBox(height: 10),
                  const Text(
                    "Founded in the heart of Colombo, Zentara was born out of a passion for precision and a vision to redefine modern luxury. Each piece we craft tells a tale of heritage, innovation, and artistry — where tradition meets timeless beauty.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              )
              // On wider screens, show Row (image + text)
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [imageWidget, textWidget],
              ),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: const Color(0xFFE3C77B).withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            "At Zentara, we create more than just watches — we create legacy. Our designs embody excellence, precision, and prestige. We partner with world-renowned craftsmen to fuse innovation with tradition, delivering pieces that are both enduring and enchanting.",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, double screenWidth) {
    // Increase the proportion and the max width
    double tileWidth = screenWidth * 0.48 > 150 ? 150 : screenWidth * 0.48;

    double avatarRadius = tileWidth / 2.1;
   

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Meet Our Team",
            style: TextStyle(
              color: Color(0xFFD1B464),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200, // Give enough room for bigger avatars + text
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                TeamMemberTile(
                  name: "Arjun Silva",
                  role: "Founder & CEO",
                  imageAsset: "assets/images/team_arjun.jpg",
                  tileWidth: tileWidth,
                  avatarRadius: avatarRadius,
                ),
                const SizedBox(width: 16),
                TeamMemberTile(
                  name: "Leena Perera",
                  role: "Head of Design",
                  imageAsset: "assets/images/team_leena.jpg",
                  tileWidth: tileWidth,
                  avatarRadius: avatarRadius,
                ),
                const SizedBox(width: 16),
                TeamMemberTile(
                  name: "Michael Lee",
                  role: "Craftsmanship Director",
                  imageAsset: "assets/images/team_michael.jpg",
                  tileWidth: tileWidth,
                  avatarRadius: avatarRadius,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Our Mission",
            style: TextStyle(
              color: Color(0xFFD1B464),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "To deliver timeless luxury through precision, elegance, and innovation.",
            style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
          ),
          SizedBox(height: 15),
          Text(
            "Our Vision",
            style: TextStyle(
              color: Color(0xFFD1B464),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "To be the world's most trusted and admired luxury timepiece brand.",
            style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: const Color(0xFFE3C77B).withOpacity(0.13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contact Us",
                style: TextStyle(
                  color: Color(0xFFD1B464),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.email, color: Color(0xFFD1B464), size: 18),
                  SizedBox(width: 8),
                  Text(
                    "support@zentara.com",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.phone, color: Color(0xFFD1B464), size: 18),
                  SizedBox(width: 8),
                  Text(
                    "+94 77 123 4567",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, color: Color(0xFFD1B464), size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "45B Luxury Avenue, Colombo 07, Sri Lanka",
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMemberTile extends StatelessWidget {
  final String name;
  final String role;
  final String imageAsset;
  final double tileWidth;
  final double avatarRadius;

  const TeamMemberTile({
    super.key,
    required this.name,
    required this.role,
    required this.imageAsset,
    required this.tileWidth,
    required this.avatarRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tileWidth,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD1B464), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD1B464).withOpacity(0.13),
                  blurRadius: 9,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(imageAsset),
              backgroundColor: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            role,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
