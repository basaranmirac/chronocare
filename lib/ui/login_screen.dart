import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/app_provider.dart';
import '../data/user_model.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true; // True ise Giriş, False ise Kayıt modu

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    if (_isLoginMode) {
      // Giriş Yapma İşlemi
      bool success = await provider.login(username, password);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı adı veya şifre hatalı!')),
        );
      }
    } else {
      // Yeni Kayıt İşlemi
      User newUser = User(username: username, password: password, role: 'musteri');
      await provider.repository.register(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt Başarılı! Şimdi giriş yapabilirsiniz.')),
      );

      // Kayıt olduktan sonra ekranı Giriş moduna geri çevir
      setState(() {
        _isLoginMode = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.watch, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'CHRONOCARE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode ? 'Servis Paneline Giriş Yapın' : 'Yeni Müşteri Kaydı Oluşturun',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Kullanıcı Adı Alanı
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  prefixIcon: const Icon(Icons.person, color: Colors.amber),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Şifre Alanı
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Ana Buton (Giriş veya Kayıt)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submit,
                  child: Text(
                    _isLoginMode ? 'GİRİŞ YAP' : 'KAYIT OL',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mod Değiştirme Butonu
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = !_isLoginMode; // Modu tersine çevir
                  });
                },
                child: Text(
                  _isLoginMode
                      ? 'Hesabınız yok mu? Hemen Kayıt Olun'
                      : 'Zaten hesabınız var mı? Giriş Yapın',
                  style: const TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}