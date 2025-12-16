import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/place.dart';

class FavoritesDB {
  static Database? _database;
  static const String _tableName = 'favorites';

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'travel_guide.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            placeId INTEGER UNIQUE,
            name TEXT NOT NULL,
            city TEXT NOT NULL,
            category TEXT NOT NULL,
            image TEXT,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            rating REAL
          )
        ''');
      },
    );
  }

  /// Add a place to favorites
  Future<void> addFavorite(Place place) async {
    final db = await database;

    await db.insert(_tableName, {
      'placeId': place.id,
      'name': place.name,
      'city': place.city,
      'category': placeCategoryToDisplayString(place.category),
      'image': place.images.isNotEmpty ? place.images.first : null,
      'lat': place.latitude,
      'lng': place.longitude,
      'rating': place.rating,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove a place from favorites
  Future<void> removeFavorite(int placeId) async {
    final db = await database;

    await db.delete(_tableName, where: 'placeId = ?', whereArgs: [placeId]);
  }

  /// Get all favorite places
  Future<List<Place>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Place(
        id: maps[i]['placeId'],
        name: maps[i]['name'],
        city: maps[i]['city'],
        category: placeCategoryFromString(maps[i]['category'] as String),
        description: '', // Description is not stored in favorites
        images: maps[i]['image'] != null ? [maps[i]['image']] : [],
        latitude: maps[i]['lat'],
        longitude: maps[i]['lng'],
        rating: maps[i]['rating'] ?? 0.0,
      );
    });
  }

  /// Check if a place is in favorites
  Future<bool> isFavorite(int placeId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'placeId = ?',
      whereArgs: [placeId],
    );
    return result.isNotEmpty;
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
