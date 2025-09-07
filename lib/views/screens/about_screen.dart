import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final bool isWide = screenWidth > 800;
        final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final double heroHeight = isWide || isLandscape ? screenWidth * 0.55 : screenWidth * 0.9;
        final colorScheme = Theme.of(context).colorScheme;

        EdgeInsets mainPadding = EdgeInsets.symmetric(
          horizontal: isWide ? 60 : 0,
          vertical: 10,
        );

        Widget mainColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context, heroHeight),
            _buildSectionDivider(),
            _buildQuoteSection(context),
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
        );

        if (isWide) {
          mainColumn = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(context, heroHeight),
                    _buildSectionDivider(),
                    _buildBrandStory(context),
                    _buildSectionDivider(),
                    _buildAboutContent(context),
                    _buildSectionDivider(),
                    _buildMissionVisionSection(context),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Right column
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuoteSection(context),
                    _buildSectionDivider(),
                    _buildTeamSection(context, screenWidth), // Always horizontal!
                    _buildSectionDivider(),
                    _buildContactInfo(context),
                  ],
                ),
              ),
            ],
          );
        }

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: mainPadding,
              child: mainColumn,
            ),
          ),
        );
      },
    );
  }

  /// Hero banner with background image and overlay
  Widget _buildHeroBanner(BuildContext context, double heroHeight) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Semantics(
          label: "Hero image of luxury watch for accessibility",
          child: SizedBox(
            height: heroHeight,
            width: double.infinity,
            child: Image.asset('assets/images/heroabt.jpg', fit: BoxFit.cover),
          ),
        ),
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.7),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
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
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
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

  /// Decorative gold divider
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

  /// Quote Section for luxury brand touch
  Widget _buildQuoteSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
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

  /// Responsive Brand Story: Image and Text side by side or stacked
  Widget _buildBrandStory(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    bool isNarrow = screenWidth < 500;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/watchmaking.jpg',
        height: isNarrow ? 200 : 170,
        width: isNarrow ? double.infinity : 120,
        fit: BoxFit.cover,
      ),
    );

    final textWidget = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 6),
        child: Text(
          "Founded in the heart of Colombo, Zentara was born out of a passion for precision and a vision to redefine modern luxury. Each piece we craft tells a tale of heritage, innovation, and artistry — where tradition meets timeless beauty.",
                       style: textTheme.bodyMedium?.copyWith(
                         color: colorScheme.onSurface,
                         fontSize: 14,
                         height: 1.4,
                       ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Story",
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          isNarrow
              ? Column(
                  children: [
                    imageWidget,
                    const SizedBox(height: 10),
                    Text(
                      "Founded in the heart of Colombo, Zentara was born out of a passion for precision and a vision to redefine modern luxury. Each piece we craft tells a tale of heritage, innovation, and artistry — where tradition meets timeless beauty.",
                       style: textTheme.bodyMedium?.copyWith(
                         color: colorScheme.onSurface,
                         fontSize: 14,
                         height: 1.4,
                       ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [imageWidget, textWidget],
                ),
        ],
      ),
    );
  }

  /// About Content Section
  Widget _buildAboutContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.primary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            "At Zentara, we create more than just watches — we create legacy. Our designs embody excellence, precision, and prestige. We partner with world-renowned craftsmen to fuse innovation with tradition, delivering pieces that are both enduring and enchanting.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

    /// Team Section with horizontal scroll and responsive sizing
  Widget _buildTeamSection(BuildContext context, double screenWidth) {
    // Use a percentage of available height for avatar, max 80 on small, up to 110 on big
    final isNarrow = screenWidth < 600;
    final double tileWidth = isNarrow ? screenWidth * 0.48 : 160;
    final double avatarRadius = isNarrow
        ? (tileWidth / 2.3).clamp(34.0, 60.0)
        : 55; // Clamp for safety, adjust as you like

    final double tileHeight = avatarRadius * 2 + 44; // Avatar + text + padding

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final team = [
      {
        "name": "Arjun Silva",
        "role": "Founder & CEO",
        "imageAsset": "assets/images/team_arjun.jpg"
      },
      {
        "name": "Leena Perera",
        "role": "Head of Design",
        "imageAsset": "assets/images/team_leena.jpg"
      },
      {
        "name": "Michael Lee",
        "role": "Craftsmanship Director",
        "imageAsset": "assets/images/team_michael.jpg"
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Meet Our Team",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: tileHeight + 24, // Add a bit more for safe padding
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: team.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) => TeamMemberTile(
                name: team[i]["name"]!,
                role: team[i]["role"]!,
                imageAsset: team[i]["imageAsset"]!,
                tileWidth: tileWidth,
                avatarRadius: avatarRadius,
                tileHeight: tileHeight,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mission & Vision Section with brand gold accent
  Widget _buildMissionVisionSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Mission",
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "To deliver timeless luxury through precision, elegance, and innovation.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Our Vision",
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "To be the world's most trusted and admired luxury timepiece brand.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Contact Info Card (uses theme for colors)
  Widget _buildContactInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        color: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.primary.withValues(alpha: 0.13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Us",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.email, color: colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "support@zentara.com",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, color: colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "+94 77 123 4567",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, color: colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "45B Luxury Avenue, Colombo 07, Sri Lanka",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 13,
                      ),
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

/// Updated TeamMemberTile to be vertically flexible and avoid overflow
class TeamMemberTile extends StatelessWidget {
  final String name;
  final String role;
  final String imageAsset;
  final double tileWidth;
  final double avatarRadius;
  final double tileHeight;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const TeamMemberTile({
    super.key,
    required this.name,
    required this.role,
    required this.imageAsset,
    required this.tileWidth,
    required this.avatarRadius,
    required this.tileHeight,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tileWidth,
      height: tileHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.13),
                  blurRadius: 9,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(imageAsset),
              backgroundColor: colorScheme.onInverseSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            role,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
