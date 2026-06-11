import 'package:flutter/material.dart';
import '../data/user_model.dart';
import 'app_repository.dart';

class AppProvider extends ChangeNotifier {
  // Veritabanı işlemleri için repository bağlantısı
  final AppRepository repository = AppRepository();

  // State'te tutulan anlık veriler
  User? _currentUser;
  bool _isDarkMode = true; // Varsayılan olarak Koyu Tema aktif


  User? get currentUser => _currentUser;
  bool get isDarkMode => _isDarkMode;

  // --- KULLANICI İŞLEMLERİ ---

  // Giriş Yapma
  Future<bool> login(String username, String password) async {
    final user = await repository.login(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Çıkış Yapma (Logout)
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // --- TEMA İŞLEMLERİ ---

  // Açık/Koyu Tema Değiştirici
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Temayı değiştirdiğimiz an tüm uygulamayı yeniden çizer
  }
}