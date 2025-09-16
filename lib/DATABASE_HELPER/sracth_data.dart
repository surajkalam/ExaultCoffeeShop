// // services/scratch_card_database.dart
// import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class ScratchCardDatabase {
//   static final ScratchCardDatabase _instance = ScratchCardDatabase._internal();
//   factory ScratchCardDatabase() => _instance;
//   ScratchCardDatabase._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'scratch_cards.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE scratch_cards(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         isScratched INTEGER NOT NULL,
//         createdAt INTEGER NOT NULL,
//         reward TEXT NOT NULL,
//         isClaimed INTEGER NOT NULL,
//         imagePath TEXT NOT NULL
//       )
//     ''');
//   }

//   Future<int> insertScratchCard(ScratchCardModel card) async {
//     final db = await database;
//     return await db.insert('scratch_cards', card.toMap());
//   }

//   Future<List<ScratchCardModel>> getAllScratchCards() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('scratch_cards');
//     return List.generate(maps.length, (i) => ScratchCardModel.fromMap(maps[i]));
//   }

//   Future<ScratchCardModel?> getLatestScratchCard() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'scratch_cards',
//       orderBy: 'createdAt DESC',
//       limit: 1,
//     );
//     if (maps.isNotEmpty) {
//       return ScratchCardModel.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> updateScratchCard(ScratchCardModel card) async {
//     final db = await database;
//     return await db.update(
//       'scratch_cards',
//       card.toMap(),
//       where: 'id = ?',
//       whereArgs: [card.id],
//     );
//   }

//   Future<void> close() async {
//     final db = await database;
//     await db.close();
//   }
// }
// services/scratch_card_database.dart
import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ScratchCardDatabase {
  static final ScratchCardDatabase _instance = ScratchCardDatabase._internal();
  factory ScratchCardDatabase() => _instance;
  ScratchCardDatabase._internal();

  static Database? _database;
  static const int _currentVersion = 2; // Increment version number

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'scratch_cards.db');
    return await openDatabase(
      path,
      version: _currentVersion, // Use the updated version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add upgrade handler
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scratch_cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isScratched INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        reward TEXT NOT NULL,
        isClaimed INTEGER NOT NULL,
        imagePath TEXT NOT NULL
      )
    '''); 
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the imagePath column for existing databases
      await db.execute('ALTER TABLE scratch_cards ADD COLUMN imagePath TEXT');
    }
  }

  Future<int> insertScratchCard(ScratchCardModel card) async {
    final db = await database;
    return await db.insert('scratch_cards', card.toMap());
  }

  Future<List<ScratchCardModel>> getAllScratchCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('scratch_cards');
    return List.generate(maps.length, (i) => ScratchCardModel.fromMap(maps[i]));
  }

  Future<ScratchCardModel?> getLatestScratchCard() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scratch_cards',
      orderBy: 'createdAt DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return ScratchCardModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateScratchCard(ScratchCardModel card) async {
    final db = await database;
    return await db.update(
      'scratch_cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}