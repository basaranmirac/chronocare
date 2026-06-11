class User {
  final int? id; // SQLite otomatik ID vereceği için başlangıçta null olabilir
  final String username;
  final String password;
  final String role; // "admin" veya "musteri"

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  // Veritabanına yazma işlemi için objeyi Map'e dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
    };
  }

  // Veritabanından veri okurken Map'i tekrar User objesine dönüştürür
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      username: map['username'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
    );
  }
}