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
      await db.execute("CREATE TABLE data (id INTEGER PRIMARY KEY, Clicks INTEGER, ShopItemsBought INTEGER, Multiplier INTEGER, ForFreePeriodically INTEGER, Rebirths INTEGER)");
      await db.insert("data", {"id": 1, "Clicks": 0, "ShopItemsBought": 0, "Multiplier": 1, "ForFreePeriodically": 0, "Rebirths": 0}, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.execute("CREATE TABLE quests (QuestID INTEGER UNIQUE, QuestName TEXT, QuestType TEXT, Goal INTEGER, Reward INTEGER, TimeLimit INTEGER, Completed INTEGER)");
      await db.insert("quests", {
        "QuestID": 1, "QuestName": "Click 100 Times", "QuestType": "Click", "Goal": 100, "Reward": 100, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 2, "QuestName": "Click 1,000 Times", "QuestType": "Click", "Goal": 1000, "Reward": 1000, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 3, "QuestName": "Click 5,000 Times", "QuestType": "Click", "Goal": 5000, "Reward": 5000, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 4, "QuestName": "Click 250 Times in 60 Seconds", "QuestType": "Quick", "Goal": 250, "Reward": 1000, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 5, "QuestName": "Click 500 Times in 60 Seconds", "QuestType": "Quick", "Goal": 500, "Reward": 2000, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 6, "QuestName": "Click 1000 Times in 60 Seconds", "QuestType": "Quick", "Goal": 1000, "Reward": 5000, "TimeLimit": 60, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 7, "QuestName": "Buy 1 Shop Item", "QuestType": "Shop", "Goal": 1, "Reward": 250, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 8, "QuestName": "Buy 10 Shop Items", "QuestType": "Shop", "Goal": 10, "Reward": 2500, "TimeLimit": 0, "Completed": 0
        }, conflictAlgorithm: ConflictAlgorithm.ignore
      );
      await db.insert("quests", {
        "QuestID": 9, "QuestName": "Buy 25 Shop Items", "QuestType": "Shop", "Goal": 25, "Reward": 7500, "TimeLimit": 0, "Completed": 0
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

  Future<int> getMultiplier() async {
    final db = await database;
    var result = await db.query("data", where: "id = 1");
    if (result.isNotEmpty) {
      return result.first["Multiplier"] as int;
    }
    return 1;
  }

  Future<int> getForFreePeriodically() async {
    final db = await database;
    var result = await db.query("data", where: "id = 1");
    if (result.isNotEmpty) {
      return result.first["ForFreePeriodically"] as int;
    }
    return 0;
  }

  Future<int> getRebirths() async {
    final db = await database;
    var result = await db.query("data", where: "id = 1");
    if (result.isNotEmpty) {
      return result.first["Rebirths"] as int;
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

  Future<void> updateMultiplier(int multiplier) async {
    final db = await database;
    await db.update("data", {"Multiplier": multiplier}, where: "id = 1");
  }

  Future<void> updateForFreePeriodically(int forFree) async {
    final db = await database;
    await db.update("data", {"ForFreePeriodically": forFree}, where: "id = 1");
  }
  
  Future<void> updateRebirths(int rebirths) async {
    final db = await database;
    await db.update("data", {"Rebirths": rebirths}, where: "id = 1");
  }

  Future<void> updateQuestCompletion(int questID, int status) async {
    final db = await database;
    await db.update("quests", {"Completed": status}, where: "QuestID = $questID");
  }
}