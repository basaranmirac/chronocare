class Watch {
  final int? id;
  final String brand;       // Örn: Seiko, Orient
  final String modelName;   // Örn: Prospex Samurai
  final int ownerId;        // Bu saat kime ait? 
  final String caliber;     // Örn: NH35, 4R35, SW200

  Watch({
    this.id,
    required this.brand,
    required this.modelName,
    required this.ownerId,
    required this.caliber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'modelName': modelName,
      'ownerId': ownerId,
      'caliber': caliber,
    };
  }

  factory Watch.fromMap(Map<String, dynamic> map) {
    return Watch(
      id: map['id'] != null ? map['id'] as int : null,
      brand: map['brand'] as String,
      modelName: map['modelName'] as String,
      ownerId: map['ownerId'] as int,
      caliber: map['caliber'] as String,
    );
  }
}