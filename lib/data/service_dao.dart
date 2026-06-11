import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'service_model.dart';

class ServiceDao {
  final dbHelper = DatabaseHelper.instance;

  // Yeni servis/arıza kaydı oluşturma
  Future<int> insertServiceTicket(ServiceTicket ticket) async {
    Database db = await dbHelper.database;
    return await db.insert('services', ticket.toMap());
  }

  // Belirli bir saate ait servis geçmişini getirme
  Future<List<ServiceTicket>> getServicesByWatchId(int watchId) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'services',
      where: 'watchId = ?',
      whereArgs: [watchId],
    );
    return maps.map((map) => ServiceTicket.fromMap(map)).toList();
  }

  // Servis durumunu güncelleme - Admin yetkisi
  Future<int> updateServiceStatus(int id, String newStatus) async {
    Database db = await dbHelper.database;
    return await db.update(
      'services',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Servis kaydını silme
  Future<int> deleteServiceTicket(int id) async {
    Database db = await dbHelper.database;
    return await db.delete('services', where: 'id = ?', whereArgs: [id]);
  }

  // Servis kaydının metnini/detayını güncelleme
  Future<int> updateServiceTicket(ServiceTicket ticket) async {
    Database db = await dbHelper.database;
    return await db.update('services', ticket.toMap(), where: 'id = ?', whereArgs: [ticket.id]);
  }
}