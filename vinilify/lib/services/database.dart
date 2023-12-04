import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '/models/vinyl.dart';

class VinylDatabase {
  late Database _database;

  static final VinylDatabase _instance = VinylDatabase._internal();

  factory VinylDatabase() {
    return _instance;
  }

  VinylDatabase._internal();

  Future<void> openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'vinilify.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE vinyls (vinyl_id INTEGER PRIMARY KEY, title TEXT NOT NULL, author TEXT NOT NULL, yearOfRelease INTEGER NOT NULL, notes TEXT, coverImageUrl TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Vinyl>> getVinyls() async {
    final List<Map<String, dynamic>> vinylsMapList =
        await _database.query('vinyls');

    return List.generate(vinylsMapList.length, (i) {
      return Vinyl(
        id: vinylsMapList[i]['vinyl_id'],
        title: vinylsMapList[i]['title'],
        author: vinylsMapList[i]['author'],
        yearOfRelease: vinylsMapList[i]['yearOfRelease'],
        coverImageUrl: vinylsMapList[i]['coverImageUrl'],
        notes: vinylsMapList[i]['notes'],
      );
    });
  }

  Future<int> insertVinyl(Vinyl vinyl) async {
    try {
      int primaryKey = await _database.insert('vinyls', vinyl.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Vinyl inserted with ID: $primaryKey');
      return primaryKey;
    } catch (e) {
      print('Error inserting vinyl: $e');
      return -1;
    }
  }

  Future<int> updateVinyl(int id, Vinyl vinyl) async {
    try {
      int count = await _database.update(
        'vinyls',
        vinyl.toMap(),
        where: 'vinyl_id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return count;
    } catch (e) {
      print('Error updating vinyl: $e');
      return -1;
    }
  }

  Future<int> deleteVinyl(int id) async {
    try {
      int count = await _database
          .delete('vinyls', where: 'vinyl_id = ?', whereArgs: [id]);
      return count;
    } catch (e) {
      return -1;
    }
  }
}
