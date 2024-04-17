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
      await db.execute("CREATE TABLE data (id INTEGER PRIMARY KEY, Clicks INTEGER, ShopItemsBought INTEGER)");
      await db.insert("data", {"id": 1, "Clicks": 0, "ShopItemsBought": 0}, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.execute("CREATE TABLE quests (QuestID INTEGER UNIQUE, QuestName TEXT, Goal INTEGER, TimeLimit INTEGER, Completed INTEGER)");
      await db.insert("quests", {
        "QuestID": 1, "QuestName": "Click 100 Times", "Goal": 100, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 2, "QuestName": "Click 1,000 Times", "Goal": 1000, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 3, "QuestName": "Click 5,000 Times", "Goal": 500, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 4, "QuestName": "Click 250 Times in 60 Seconds", "Goal": 250, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 5, "QuestName": "Click 500 Times in 60 Seconds", "Goal": 500, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 6, "QuestName": "Click 1000 Times in 60 Seconds", "Goal": 1000, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 7, "QuestName": "Buy 1 Shop Item", "Goal": 1, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 8, "QuestName": "Buy 10 Shop Items", "Goal": 10, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 9, "QuestName": "Buy 25 Shop Itens", "Goal": 25, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
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

  Future<int> getShopItemsBought() async {
    final db = await database;
    var result = await db.query("data", where: "id = 1");
    if (result.isNotEmpty) {
      return result.first["ShopItemsBought"] as int;
    }
    return 0;
  }

  Future<int> getQuestCompletion(int questID) async {
    final db = await database;
    var result = await db.query("quests", where: "QuestID = $questID");
    if (result.isNotEmpty) {
      return result.first["Completed"] as int;
    }
    return 0;
  }

  Future<List<Map>> getQuests() async {
    final db = await database;
    return await db.query("quests");
  }

  Future<void> updateClicks(int clicks) async {
    final db = await database;
    await db.update("data", {"Clicks": clicks}, where: "id = 1");
  }

  Future<void> updateShopItemsBought(int items) async {
    final db = await database;
    await db.update("data", {"ShopItemsBought": items}, where: "id = 1");
  }

  Future<void> updateQuestCompletion(int questID) async {
    final db = await database;
    await db.update("quests", {"Completed": 1}, where: "QuestID = $questID");
  }
}