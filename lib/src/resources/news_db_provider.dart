import 'dart:io';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  // we can't have init in constructor since constructor can't be async
  // NewsDbProvider() async {}
  NewsDbProvider() {
    init();
  }

// create db or re-open the db if previously created
  void init() async {
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory(); // folder ref
    final path = join(documentsDirectory.path, "items.db"); // join the strings

    // create or open the db
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        // create table ("""...""" for multi-line code, sql does not have bool so we use INT 0/1)
        newDb.execute(""" 
          CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      },
    );
  }

  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      where: "id = ?", // avoid sql injection
      whereArgs: [id],
      columns: null,
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      'Items',
      item.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<int>> fetchTopIds() {
    // todo: implement fetchTopIds
    throw UnimplementedError();
  }

  Future<int> clearDb() {
    return db.delete("Items");
  }
}

final myNewsDbProvider =
    NewsDbProvider(); // for using single instance and avoid opening multiple db connection