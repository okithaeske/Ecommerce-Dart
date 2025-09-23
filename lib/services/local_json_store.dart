import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/product.dart';

class LocalJsonStore {
  static const int schemaVersion = 1;
  static const String _productsFileName = 'products.json';

  static Future<File> _productsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_productsFileName');
  }

  static Future<void> writeProducts(List<Product> products) async {
    final file = await _productsFile();
    final tmp = File('${file.path}.tmp');
    final payload = {
      'schemaVersion': schemaVersion,
      'updatedAt': DateTime.now().toIso8601String(),
      'items': products.map((p) => p.toJson()).toList(),
    };
    final jsonStr = const JsonEncoder.withIndent('  ').convert(payload);
    await tmp.writeAsString(jsonStr, flush: true);
    // Atomic replace: rename temp to final path
    if (await file.exists()) {
      await file.delete();
    }
    await tmp.rename(file.path);
  }

  static Future<List<Product>?> readProductsIfExists() async {
    final file = await _productsFile();
    if (!await file.exists()) return null;
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      if (data is! Map<String, dynamic>) return null;
      final ver = data['schemaVersion'] is int ? data['schemaVersion'] as int : 0;
      if (ver < 1) return null; // basic version gate
      final items = data['items'];
      if (items is! List) return null;
      return items
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (_) {
      return null;
    }
  }
}

