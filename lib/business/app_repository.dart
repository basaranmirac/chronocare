import '../data/user_dao.dart';
import '../data/watch_dao.dart';
import '../data/service_dao.dart';
import '../data/user_model.dart';
import '../data/watch_model.dart';
import '../data/service_model.dart';

class AppRepository {
  // DAO sınıflarının instance'ları
  final UserDao _userDao = UserDao();
  final WatchDao _watchDao = WatchDao();
  final ServiceDao _serviceDao = ServiceDao();

  // --- KULLANICI İŞLEMLERİ ---
  Future<int> register(User user) async {
    return await _userDao.insertUser(user);
  }

  Future<User?> login(String username, String password) async {
    return await _userDao.loginUser(username, password);
  }

  Future<int> deleteAccount(int userId) async {
    return await _userDao.deleteUser(userId);
  }

  // --- SAAT İŞLEMLERİ ---
  Future<int> addWatch(Watch watch) async {
    return await _watchDao.insertWatch(watch);
  }

  Future<List<Watch>> getUserWatches(int userId) async {
    return await _watchDao.getWatchesByUserId(userId);
  }

  Future<int> removeWatch(int watchId) async {
    return await _watchDao.deleteWatch(watchId);
  }

  // --- SERVİS İŞLEMLERİ ---
  Future<int> createTicket(ServiceTicket ticket) async {
    return await _serviceDao.insertServiceTicket(ticket);
  }

  Future<List<ServiceTicket>> getWatchHistory(int watchId) async {
    return await _serviceDao.getServicesByWatchId(watchId);
  }

  Future<int> updateTicketStatus(int ticketId, String newStatus) async {
    return await _serviceDao.updateServiceStatus(ticketId, newStatus);
  }

  Future<int> deleteTicket(int ticketId) async {
    return await _serviceDao.deleteServiceTicket(ticketId);
  }

  Future<int> updateTicketFull(ServiceTicket ticket) async {
    return await _serviceDao.updateServiceTicket(ticket);
  }
}