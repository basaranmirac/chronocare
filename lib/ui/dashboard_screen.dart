import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/app_provider.dart';
import '../data/watch_model.dart';
import 'add_watch_screen.dart';
import 'profile_screen.dart';
import 'service_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Watch> _myWatches = [];
  int _pendingServiceCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWatches();
  }

  Future<void> _loadWatches() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;

    if (user != null && user.id != null) {
      final watches = await provider.repository.getUserWatches(user.id!);

      int pending = 0;
      for (var watch in watches) {
        final tickets = await provider.repository.getWatchHistory(watch.id!);
        pending += tickets.where((t) => t.status == 'Bekliyor').length;
      }

      setState(() {
        _myWatches = watches;
        _pendingServiceCount = pending;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context, listen: false).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user?.username} Koleksiyonu', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. İSTATİSTİK KARTI
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.watch, color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    const Text('Toplam Saat', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('${_myWatches.length}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Container(width: 1, height: 60, color: Colors.grey.withOpacity(0.3)),
                Column(
                  children: [
                    const Icon(Icons.build_circle_outlined, color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    const Text('Bekleyen Servis', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    // Dinamik sayacımızı buraya yerleştirdik
                    Text('$_pendingServiceCount', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Kayıtlı Saatler', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          // 2. SAATLERİN LİSTESİ
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : _myWatches.isEmpty
                ? const Center(child: Text("Koleksiyonunuz boş.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: _myWatches.length,
              itemBuilder: (context, index) {
                final watch = _myWatches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.watch, color: Colors.amber, size: 32),
                    ),
                    title: Text('${watch.brand} ${watch.modelName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Mekanizma: ${watch.caliber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () async {
                            final provider = Provider.of<AppProvider>(context, listen: false);
                            await provider.repository.removeWatch(watch.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saat koleksiyondan silindi.')));
                            }
                            setState(() { _isLoading = true; });
                            _loadWatches();
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                      ],
                    ),
                    onTap: () async {
                      // Servis detayına gidip geri döndüğümüzde sayıları güncellemek için bekliyoruz
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen(watch: watch)));
                      setState(() { _isLoading = true; });
                      _loadWatches();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 3. TAM ORTAYA OTURAN BUTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.black, size: 32),
        onPressed: () async {
          final shouldRefresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddWatchScreen()));
          if (shouldRefresh == true) {
            setState(() { _isLoading = true; });
            _loadWatches();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 4. KAVİSLİ ALT NAVİGASYON
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.amber, size: 30),
                onPressed: () {},
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.grey, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}