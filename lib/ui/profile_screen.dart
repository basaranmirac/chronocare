import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/app_provider.dart';
import 'login_screen.dart';
import 'privacy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Hesap silme onay penceresi
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Hesabı Sil', style: TextStyle(color: Colors.redAccent)),
          content: const Text('Hesabınızı, tüm saat koleksiyonunuzu ve servis geçmişinizi kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
          actions: [
            TextButton(
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Evet, Sil'),
              onPressed: () async {
                final provider = Provider.of<AppProvider>(context, listen: false);
                if (provider.currentUser?.id != null) {
                  // Veritabanından sil
                  await provider.repository.deleteAccount(provider.currentUser!.id!);
                  provider.logout();

                  // Dialogu kapat ve Login ekranına dön
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.amber,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user?.username.toUpperCase() ?? 'KULLANICI',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
          Center(
            child: Text(
              'Hesap Türü: ${user?.role.toUpperCase()}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.palette, color: Colors.amber),
            title: const Text('Uygulama Teması'),
            trailing: Text(Provider.of<AppProvider>(context).isDarkMode ? 'Koyu Tema' : 'Açık Tema', style: const TextStyle(color: Colors.grey)),
            onTap: () {
              Provider.of<AppProvider>(context, listen: false).toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.amber),
            title: const Text('Gizlilik ve Güvenlik'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyScreen()));
            },
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.amber),
            title: const Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Provider.of<AppProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
            },
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text('Hesabı Kalıcı Olarak Sil', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
    );
  }
}