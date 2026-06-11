import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'user_model.dart';

class UserDao {
  final dbHelper = DatabaseHelper.instance;

  // Yeni kullanıcı kaydı
  Future<int> insertUser(User user) async {
    Database db = await dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  // Kullanıcı girişi için doğrulama
  Future<User?> loginUser(String username, String password) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first); // Kullanıcı bulunduysa objeyi döndür
    }
    return null; // Kullanıcı yoksa null döndür
  }
// Kullanıcı silme (Delete)
  Future<int> deleteUser(int id) async {
    Database db = await dbHelper.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}

