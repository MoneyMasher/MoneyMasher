import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager {
  static Database? _database;

  DatabaseManager() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String folderPath = join(documentsDirectory.path, "MoneyMasher");
    await Directory(folderPath).create(recursive: true);
    String path = join(folderPath, "mm.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE data (id INTEGER PRIMARY KEY, Clicks INTEGER)");
      await db.insert("data", {"id": 1, "Clicks": 0});
    });
  }

  Future<int> getClicks() async {
    final db = await database;
    var result = await db.query("data", where: "id = 1");
    if (result.isNotEmpty) {
      return result.first["Clicks"] as int;
    }
    return 0;
  }

  Future<void> updateClicks(int clicks) async {
    final db = await database;
    await db.update("data", {"Clicks": clicks}, where: "id = 1");
  }
}