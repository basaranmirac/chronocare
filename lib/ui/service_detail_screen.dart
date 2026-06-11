import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../business/app_provider.dart';
import '../business/ai_advisor_service.dart';
import '../data/watch_model.dart';
import '../data/service_model.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Watch watch;
  const ServiceDetailScreen({super.key, required this.watch});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _issueController = TextEditingController();
  List<ServiceTicket> _tickets = [];
  bool _isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (widget.watch.id != null) {
      final tickets = await provider.repository.getWatchHistory(widget.watch.id!);
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() { _selectedImage = File(pickedFile.path); });
    }
  }

  void _clearImage() {
    setState(() { _selectedImage = null; });
  }

  void _createServiceTicket() async {
    final issue = _issueController.text.trim();
    if (issue.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen bir şikayet yazın veya fotoğraf yükleyin.')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) Navigator.pop(context);

    String aiRecommendation = AiAdvisorService.analyzeIssueAndRecommend(issue);
    _showAiDialog(aiRecommendation, issue);
  }

  void _showAiDialog(String aiRecommendation, String originalIssue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('AI Analizi', style: TextStyle(color: Colors.amber)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null) ...[
              const Text('📷 Görsel taraması tamamlandı.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
            ],
            Text(aiRecommendation),
          ],
        ),
        actions: [
          TextButton(child: const Text('İptal', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            child: const Text('Kaydı Oluştur'),
            onPressed: () {
              Navigator.pop(context);
              _saveTicketToDb(originalIssue, aiRecommendation);
            },
          )
        ],
      ),
    );
  }

  void _saveTicketToDb(String issue, String aiRec) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final newTicket = ServiceTicket(
      watchId: widget.watch.id!,
      issue: "${_selectedImage != null ? '[Fotoğraflı] ' : ''}$issue\n\n$aiRec",
      status: 'Bekliyor',
      estimatedDays: 7,
      cost: 0.0,
    );
    await provider.repository.createTicket(newTicket);
    _issueController.clear();
    _clearImage();
    setState(() { _isLoading = true; });
    _loadTickets();
  }

  //SİLME VE DÜZENLEME FONKSİYONLARI

  void _deleteTicket(int ticketId) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.repository.deleteTicket(ticketId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Servis kaydı silindi.')));
    setState(() { _isLoading = true; });
    _loadTickets();
  }

  void _showEditDialog(ServiceTicket ticket) {
    final editController = TextEditingController(text: ticket.issue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Kaydı Düzenle', style: TextStyle(color: Colors.amber)),
        content: TextField(
          controller: editController,
          maxLines: 4,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        actions: [
          TextButton(child: const Text('İptal', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            child: const Text('Güncelle'),
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              final updatedTicket = ServiceTicket(
                id: ticket.id,
                watchId: ticket.watchId,
                issue: editController.text,
                status: ticket.status,
                estimatedDays: ticket.estimatedDays,
                cost: ticket.cost,
              );
              await provider.repository.updateTicketFull(updatedTicket);
              if(context.mounted) Navigator.pop(context);
              setState(() { _isLoading = true; });
              _loadTickets();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.watch.modelName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.amber.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.amber),
                title: Text('${widget.watch.brand} ${widget.watch.modelName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Mekanizma: ${widget.watch.caliber}'),
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedImage != null)
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 8, top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _clearImage),
                    ),
                  )
                ],
              ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _issueController,
                    decoration: InputDecoration(
                      labelText: 'Şikayetinizi yazın...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: IconButton(icon: const Icon(Icons.camera_alt, color: Colors.amber), onPressed: _pickImage),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _createServiceTicket,
                  child: const Icon(Icons.auto_awesome),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Servis Geçmişi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Divider(color: Colors.grey),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                  : _tickets.isEmpty
                  ? const Center(child: Text('Bu saate ait servis kaydı yok.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  return Card(
                    color: const Color(0xFF1E1E1E),
                    child: ListTile(
                      title: Text('Durum: ${ticket.status}', style: TextStyle(color: ticket.status == 'Tamamlandı' ? Colors.green : Colors.orange)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(ticket.issue),
                      ),
                      //DÜZENLE VE SİL BUTONLARI
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_note, color: Colors.blueAccent),
                            onPressed: () => _showEditDialog(ticket),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _deleteTicket(ticket.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}