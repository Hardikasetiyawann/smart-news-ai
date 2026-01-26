import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/bookmark_model.dart';

abstract class BookmarkLocalDataSource {
  Future<void> addBookmark(BookmarkModel bookmark);
  Future<void> removeBookmark(String id);
  Future<List<BookmarkModel>> getBookmarks();
  Future<bool> isBookmarked(String id);
  Future<void> clearBookmarks();
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'bookmark.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id TEXT PRIMARY KEY,
            title TEXT,
            image_url TEXT,
            category TEXT,
            publisher TEXT,
            publisher_logo TEXT,
            time TEXT,
            content TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE bookmarks ADD COLUMN content TEXT');
        }
      },
    );
  }

  @override
  Future<void> addBookmark(BookmarkModel bookmark) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeBookmark(String id) async {
    final db = await database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<BookmarkModel>> getBookmarks() async {
    final db = await database;
    final result = await db.query('bookmarks');

    return result.map((e) => BookmarkModel.fromMap(e)).toList();
  }

  @override
  Future<bool> isBookmarked(String id) async {
    final db = await database;
    final result = await db.query(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> clearBookmarks() async {
    final db = await database;
    await db.delete('bookmarks');
  }
}
