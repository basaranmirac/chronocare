class ServiceTicket {
  final int? id;
  final int watchId;         // Hangi saate işlem yapılıyor? (Watch tablosundaki id)
  final String issue;        // Şikayet 
  final String status;       // Durum (Bekliyor, İşlemde, Tamamlandı)
  final int estimatedDays;   // Tahmini teslim süresi (Gün)
  final double cost;         // Maliyet

  ServiceTicket({
    this.id,
    required this.watchId,
    required this.issue,
    required this.status,
    required this.estimatedDays,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'watchId': watchId,
      'issue': issue,
      'status': status,
      'estimatedDays': estimatedDays,
      'cost': cost,
    };
  }

  factory ServiceTicket.fromMap(Map<String, dynamic> map) {
    return ServiceTicket(
      id: map['id'] != null ? map['id'] as int : null,
      watchId: map['watchId'] as int,
      issue: map['issue'] as String,
      status: map['status'] as String,
      estimatedDays: map['estimatedDays'] as int,
      cost: (map['cost'] as num).toDouble(),
    );
  }
}