// Lightweight fuzzy matching utilities (no external deps)

List<String> _tokens(String s) => s
    .toLowerCase()
    .split(RegExp(r"[^a-z0-9]+"))
    .where((t) => t.isNotEmpty)
    .toList();

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

double _similarity(String a, String b) {
  if (a.isEmpty && b.isEmpty) return 1.0;
  final d = _levenshtein(a.toLowerCase(), b.toLowerCase());
  final maxLen = a.length > b.length ? a.length : b.length;
  return 1.0 - (d / maxLen);
}

double _jaccardTokens(String a, String b) {
  final ta = _tokens(a).toSet();
  final tb = _tokens(b).toSet();
  if (ta.isEmpty && tb.isEmpty) return 1.0;
  final inter = ta.intersection(tb).length.toDouble();
  final uni = ta.union(tb).length.toDouble();
  if (uni == 0) return 0.0;
  return inter / uni;
}

double scoreTextMatch({required String text, required String query}) {
  // Blend character-level similarity and token overlap
  final sim = _similarity(text, query); // 0..1
  final jac = _jaccardTokens(text, query); // 0..1
  return (0.7 * sim) + (0.3 * jac);
}

double scoreProduct({required String name, required String description, required String query}) {
  final nameScore = scoreTextMatch(text: name, query: query);
  final descScore = scoreTextMatch(text: description, query: query) * 0.8; // slightly downweight description
  // Favor name matches, but allow strong description matches
  return nameScore >= descScore ? nameScore : descScore;
}

