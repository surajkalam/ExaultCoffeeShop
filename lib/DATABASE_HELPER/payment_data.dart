// database_helper.dart
import 'package:coffee_shop/Features/Profile/data/order_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 // Import your model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'payments.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        totalPrice REAL NOT NULL,
        status TEXT NOT NULL,
        completedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPayment(PaymentData payment) async {
    final db = await database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<PaymentData>> getPayments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      orderBy: 'completedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return PaymentData.fromMap(maps[i]);
    });
  }

  Future<int> deletePayment(int id) async {
    final db = await database;
    return await db.delete(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearPayments() async {
    final db = await database;
    return await db.delete('payments');
  }
  
}