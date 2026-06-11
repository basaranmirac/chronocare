import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'watch_model.dart';

class WatchDao {
  final dbHelper = DatabaseHelper.instance;

  // Yeni saat ekleme
  Future<int> insertWatch(Watch watch) async {
    Database db = await dbHelper.database;
    return await db.insert('watches', watch.toMap());
  }

  // Belirli bir kullanıcıya ait saatleri getirme
  Future<List<Watch>> getWatchesByUserId(int userId) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'watches',
      where: 'ownerId = ?',
      whereArgs: [userId],
    );
    // Gelen Map listesini Watch objeleri listesine çevirir
    return maps.map((map) => Watch.fromMap(map)).toList();
  }

  // Saat silme
  Future<int> deleteWatch(int id) async {
    Database db = await dbHelper.database;
    return await db.delete('watches', where: 'id = ?', whereArgs: [id]);
  }
}