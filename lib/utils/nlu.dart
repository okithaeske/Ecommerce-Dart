import 'package:ecommerce/services/lexicon_service.dart';

class ParsedQuery {
  final String raw;
  final Set<String> brands;
  final Set<String> colors;
  final Set<String> types;
  final Set<String> materials;
  final Set<String> straps;
  final String? gender; // men, women, unisex
  final double? minPrice;
  final double? maxPrice;
  final List<String> residual;

  const ParsedQuery({
    required this.raw,
    required this.brands,
    required this.colors,
    required this.types,
    required this.materials,
    required this.straps,
    required this.gender,
    required this.minPrice,
    required this.maxPrice,
    required this.residual,
  });
}

// Defaults are provided by LexiconService when not specified.

List<String> tokenize(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r"[^a-z0-9\s]"), " ")
    .split(RegExp(r"\s+"))
    .where((t) => t.isNotEmpty)
    .toList();

// Basic number words mapping for price parsing
const _numberWords = <String, int>{
  'zero': 0,
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
  'ten': 10,
  'eleven': 11,
  'twelve': 12,
  'thirteen': 13,
  'fourteen': 14,
  'fifteen': 15,
  'sixteen': 16,
  'seventeen': 17,
  'eighteen': 18,
  'nineteen': 19,
  'twenty': 20,
  'thirty': 30,
  'forty': 40,
  'fifty': 50,
  'sixty': 60,
  'seventy': 70,
  'eighty': 80,
  'ninety': 90,
  'hundred': 100,
  'thousand': 1000,
};

String normalizeQuery(String input) {
  var q = input.toLowerCase();
  // Common phrase to token normalization
  q = q.replaceAll(RegExp(r"blue\s+dial"), ' blue ');
  q = q.replaceAll(RegExp(r"rose\s+gold|pink\s+gold"), ' rose ');
  q = q.replaceAll(RegExp(r"steel\s+bracelet"), ' steel bracelet ');
  q = q.replaceAll(RegExp(r"chrono\b"), ' chronograph ');

  // Convert number words to digits for simple cases
  // e.g., "ten k" -> "10k", "two thousand" -> "2k"
  final tokens = tokenize(q);
  final out = <String>[];
  for (int i = 0; i < tokens.length; i++) {
    final t = tokens[i];
    if (_numberWords.containsKey(t)) {
      // lookahead for thousand -> k
      final next = (i + 1) < tokens.length ? tokens[i + 1] : null;
      if (next == 'thousand') {
        out.add('${_numberWords[t]}k');
        i += 1; // skip 'thousand'
        continue;
      }
      out.add(_numberWords[t]!.toString());
    } else if (t == 'thousand') {
      // lone 'thousand' after a number
      if (out.isNotEmpty && RegExp(r"^\d+").hasMatch(out.last)) {
        out[out.length - 1] = out.last + 'k';
      } else {
        out.add('1000');
      }
    } else {
      out.add(t);
    }
  }
  // Rebuild query string
  return out.join(' ');
}

int _levenshtein(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;
  final m = s.length, n = t.length;
  final dp = List<int>.generate(n + 1, (j) => j);
  for (int i = 1; i <= m; i++) {
    int prev = dp[0];
    dp[0] = i;
    for (int j = 1; j <= n; j++) {
      final temp = dp[j];
      final cost = s.codeUnitAt(i - 1) == t.codeUnitAt(j - 1) ? 0 : 1;
      dp[j] = [
        dp[j] + 1, // deletion
        dp[j - 1] + 1, // insertion
        prev + cost // substitution
      ].reduce((a, b) => a < b ? a : b);
      prev = temp;
    }
  }
  return dp[n];
}

String _spellCorrect(String token, Set<String> vocab) {
  if (vocab.contains(token)) return token;
  String? best;
  double bestScore = 0.0;
  for (final v in vocab) {
    final d = _levenshtein(token, v).toDouble();
    final maxLen = token.length > v.length ? token.length : v.length;
    final score = 1.0 - (d / maxLen); // 0..1
    if (score > bestScore) {
      bestScore = score;
      best = v;
    }
  }
  return (bestScore >= 0.72) ? (best ?? token) : token; // tolerate minor errors
}

double? _parseNumber(String raw) {
  var s = raw.trim().replaceAll(RegExp(r"[\$£€\s,]"), "");
  final k = s.endsWith('k');
  if (k) s = s.substring(0, s.length - 1);
  final v = double.tryParse(s);
  if (v == null) return null;
  return k ? v * 1000.0 : v;
}

(double?, double?)? extractPrice(String query) {
  final q = query.toLowerCase();
  final between = RegExp(r"between\s+([\$£€]?\s*[\d,]+(?:\.\d+)?)\s+and\s+([\$£€]?\s*[\d,]+(?:\.\d+)?)");
  final mBetween = between.firstMatch(q);
  if (mBetween != null) {
    final a = _parseNumber(mBetween.group(1)!);
    final b = _parseNumber(mBetween.group(2)!);
    if (a != null && b != null) {
      final lo = a < b ? a : b;
      final hi = a < b ? b : a;
      return (lo, hi);
    }
  }
  final under = RegExp(r"(under|below|less than)\s+([\$£€]?\s*[\d,]+(?:\.\d+)?k?)");
  final mUnder = under.firstMatch(q);
  if (mUnder != null) {
    final v = _parseNumber(mUnder.group(2)!);
    if (v != null) return (null, v);
  }
  final over = RegExp(r"(over|above|greater than)\s+([\$£€]?\s*[\d,]+(?:\.\d+)?k?)");
  final mOver = over.firstMatch(q);
  if (mOver != null) {
    final v = _parseNumber(mOver.group(2)!);
    if (v != null) return (v, null);
  }
  return null;
}

ParsedQuery parseQuery(String raw, [LexiconConfig? config]) {
  final lex = config ?? LexiconService.instance.config;
  final normalized = normalizeQuery(raw);
  final tokens = tokenize(normalized);
  final foundBrands = <String>{};
  final foundColors = <String>{};
  final foundTypes = <String>{};
  final foundMaterials = <String>{};
  final foundStraps = <String>{};
  String? gender;

  final vocab = <String>{}
    ..addAll(lex.brands)
    ..addAll(lex.colors)
    ..addAll(lex.types)
    ..addAll(lex.materials)
    ..addAll(lex.straps)
    ..addAll(lex.brandAliases.keys);

  for (final rawT in tokens) {
    final t0 = _spellCorrect(rawT, vocab);
    final t = t0;
    final alias = lex.brandAliases[t];
    final brandToken = alias ?? t;
    if (lex.brands.contains(brandToken)) foundBrands.add(brandToken);
    if (lex.colors.contains(t)) foundColors.add(t);
    if (lex.types.contains(t)) foundTypes.add(t == 'chrono' ? 'chronograph' : t);
    if (lex.materials.contains(t)) foundMaterials.add(t);
    if (lex.straps.contains(t)) foundStraps.add(t);
    if (t == 'men' || t == 'mens' || t == 'man' || t == 'male') gender = 'men';
    if (t == 'women' || t == 'womens' || t == 'woman' || t == 'female') gender = 'women';
    if (t == 'unisex') gender = 'unisex';
  }

  final price = extractPrice(raw);

  // residual = tokens not already captured by any facet
  final captured = <String>{}
    ..addAll(foundBrands)
    ..addAll(foundColors)
    ..addAll(foundTypes)
    ..addAll(foundMaterials)
    ..addAll(foundStraps)
    ..addAll(['men','mens','man','male','women','womens','woman','female','unisex','under','below','less','than','over','above','greater','between','and']);
  final residual = tokens.where((t) => !captured.contains(t)).toList();

  return ParsedQuery(
    raw: raw,
    brands: foundBrands,
    colors: foundColors,
    types: foundTypes,
    materials: foundMaterials,
    straps: foundStraps,
    gender: gender,
    minPrice: price?.$1,
    maxPrice: price?.$2,
    residual: residual,
  );
}
