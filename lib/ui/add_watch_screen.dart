import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/app_provider.dart';
import '../data/watch_model.dart';

class AddWatchScreen extends StatefulWidget {
  const AddWatchScreen({super.key});

  @override
  State<AddWatchScreen> createState() => _AddWatchScreenState();
}

class _AddWatchScreenState extends State<AddWatchScreen> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _caliberController = TextEditingController(); // Mekanizma (Örn: NH35)

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _caliberController.dispose();
    super.dispose();
  }

  void _saveWatch() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;

    if (user == null || user.id == null) return;

    if (_brandController.text.isEmpty || _modelController.text.isEmpty || _caliberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    // Yeni Watch objesini oluşturuyoruz
    final newWatch = Watch(
      brand: _brandController.text.trim(),
      modelName: _modelController.text.trim(),
      ownerId: user.id!,
      caliber: _caliberController.text.trim(),
    );

    // Repository üzerinden SQLite veritabanına ekliyoruz
    await provider.repository.addWatch(newWatch);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saat başarıyla koleksiyona eklendi!')),
    );

    // Kayıt bitince sayfayı kapatıp Dashboard'a geri döner
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Saat Ekle', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.watch_outlined, size: 60, color: Colors.amber),
            const SizedBox(height: 24),

            TextField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: 'Marka (Örn: Seiko, Orient)',
                prefixIcon: const Icon(Icons.branding_watermark, color: Colors.amber),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: 'Model (Örn: Prospex Samurai)',
                prefixIcon: const Icon(Icons.watch, color: Colors.amber),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _caliberController,
              decoration: InputDecoration(
                labelText: 'Mekanizma Kalibresi (Örn: NH35, SW200)',
                prefixIcon: const Icon(Icons.settings, color: Colors.amber),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveWatch,
                child: const Text('KAYDET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}