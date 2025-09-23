import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LexiconConfig {
  final Set<String> brands;
  final Map<String, String> brandAliases;
  final Set<String> types;
  final Set<String> colors;
  final Set<String> materials;
  final Set<String> straps;

  const LexiconConfig({
    required this.brands,
    required this.brandAliases,
    required this.types,
    required this.colors,
    required this.materials,
    required this.straps,
  });
}

class LexiconService {
  LexiconService._();
  static final LexiconService instance = LexiconService._();

  LexiconConfig? _config;
  LexiconConfig get config => _config ?? const LexiconConfig(
        brands: {
          'rolex','omega','iwc','tissot','cartier','casio','hublot','patek','vacheron','jaeger','panerai','gucci','timex','seiko','longines','breitling','tag','tudor','richard','mille'
        },
        brandAliases: {
          'vc': 'vacheron',
          'vacheron constantin': 'vacheron',
          'tag heuer': 'tag',
          'rm': 'richard',
          'speedy': 'speedmaster',
        },
        types: {
          'chronograph','chrono','dive','diver','dress','pilot','field','gmt','skeleton'
        },
        colors: {
          'black','white','silver','gold','blue','green','red','brown','gray','grey','champagne','pink','rose'
        },
        materials: {
          'steel','stainless','titanium','gold','rose','pink','ceramic','bronze'
        },
        straps: {
          'leather','rubber','bracelet','steel bracelet','strap','silicone'
        },
      );

  Future<void> loadFromAssets([String path = 'assets/lexicon.json']) async {
    try {
      final data = await rootBundle.loadString(path);
      final json = jsonDecode(data) as Map<String, dynamic>;
      _config = LexiconConfig(
        brands: {...(json['brands'] as List).map((e) => e.toString().toLowerCase())},
        brandAliases: (json['brand_aliases'] as Map<String, dynamic>).map((k, v) => MapEntry(k.toLowerCase(), v.toString().toLowerCase())),
        types: {...(json['types'] as List).map((e) => e.toString().toLowerCase())},
        colors: {...(json['colors'] as List).map((e) => e.toString().toLowerCase())},
        materials: {...(json['materials'] as List).map((e) => e.toString().toLowerCase())},
        straps: {...(json['straps'] as List).map((e) => e.toString().toLowerCase())},
      );
    } catch (_) {
      // Use defaults on failure
    }
  }
}

