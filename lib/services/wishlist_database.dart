import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'package:ecommerce/models/wishlist_item.dart';

class WishlistDatabase {
  WishlistDatabase._();

  static final WishlistDatabase instance = WishlistDatabase._();

  static const _dbName = 'wishlist.db';
  static const _tableName = 'wishlist_items';

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }
    final path = p.join(await getDatabasesPath(), _dbName);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            product_id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price_label TEXT NOT NULL,
            image_url TEXT NOT NULL,
            description TEXT,
            added_at INTEGER NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<WishlistItem>> fetchItems() async {
    final db = await _db;
    final rows = await db.query(_tableName, orderBy: 'added_at DESC');
    return rows.map((row) => WishlistItem.fromMap(row)).toList();
  }

  Future<void> upsert(WishlistItem item) async {
    final db = await _db;
    await db.insert(
      _tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove(String productId) async {
    final db = await _db;
    await db.delete(
      _tableName,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> contains(String productId) async {
    final db = await _db;
    final rows = await db.query(
      _tableName,
      columns: ['product_id'],
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<void> clear() async {
    final db = await _db;
    await db.delete(_tableName);
  }
}
