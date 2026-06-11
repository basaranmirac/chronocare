import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _dataSharing = false;
  bool _biometricLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik ve Güvenlik'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'KVKK ve Veri Kullanım Politikası',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ),
          const Text(
            'ChronoCare, saat koleksiyonu ve servis kayıtlarınızı yalnızca cihazınızın yerel depolama (SQLite) alanında tutar. Verileriniz üçüncü şahıslarla paylaşılmaz.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Divider(),

          SwitchListTile(
            activeColor: Colors.amber,
            title: const Text('Analitik Veri Paylaşımı'),
            subtitle: const Text('Uygulamayı geliştirmemize yardımcı olun.'),
            value: _dataSharing,
            onChanged: (val) {
              setState(() { _dataSharing = val; });
            },
          ),
          SwitchListTile(
            activeColor: Colors.amber,
            title: const Text('Biyometrik Giriş (FaceID/TouchID)'),
            subtitle: const Text('Uygulama açılışında ekstra güvenlik sağlar.'),
            value: _biometricLogin,
            onChanged: (val) {
              setState(() { _biometricLogin = val; });
            },
          ),
        ],
      ),
    );
  }
}