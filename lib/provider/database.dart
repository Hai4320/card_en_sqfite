import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../model/english_card_model.dart';
import '../model/level_card_model.dart';

class DatabaseHelper with ChangeNotifier{
  static String cardTable = 'cards';
  static String levelTable = 'levels';
  static String databaseName = 'card_en.db';
  late Database database;
  bool hasDatabase = false;

  DatabaseHelper(){
    initDB();
  }
  

  Future initDB() async {
    final databasePath = await getDatabasesPath();
    database = await openDatabase(path.join(databasePath, databaseName),
        onCreate: (db, version) async {
      await db.execute(""" CREATE TABLE $levelTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name TEXT NOT NULL,
            color TEXT NOT NULL
          ) """
      );
      await insertAllLevel(db);
      await db.execute(""" CREATE TABLE $cardTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            word TEXT NOT NULL,
            mean TEXT NOT NULL,
            level INTEGER NOT NULL, 
            FOREIGN KEY (level) 
              REFERENCES $levelTable (id) 
                ON DELETE CASCADE 
                ON UPDATE NO ACTION
          ) """
      );
    }, version: 1);
    hasDatabase = true;
    notifyListeners();
  }

  Future<void> insertCard(EnglishCard data) async {
    await database.insert(cardTable, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCard(EnglishCard data) async {
    await database.update(cardTable, data.toMap(), where: 'id = ?', whereArgs: [data.id]);
  }
  
  Future<void> deleteCard(EnglishCard data) async {
    await database.delete(cardTable, where: 'id = ?', whereArgs: [data.id]);
  }
  Future<ListCard> getCardData() async {
    var data = await database.query(cardTable);
    return ListCard(data.map((e) => EnglishCard.fromMap(e)).toList());
  }
  Future<List<CardLevel>> getLevelData() async {
    var data = await database.query(levelTable);
    return data.map((e) => CardLevel.fromMap(e)).toList();
  }

  Future insertAllLevel(Database x) async {
    await x.insert(levelTable, {"id": 0, "name": "easy", "color": "56BBF1"},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await x.insert(levelTable, {"id": 1, "name": "medium", "color": "FFD93D"},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await x.insert(levelTable, {"id": 2, "name": "hard", "color": "FD5D5D"},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
