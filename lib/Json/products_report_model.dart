class InventoryBalance {
  final int? productId;
  final String? productName;
  final int? proInvId;
  final String? inventoryType;
  final int? qty;
  final double? buyPrice;
  final double? sellPrice;
  final DateTime? lastUpdated;
  final int? invId;
  final String? inventoryName;
  final int? currentInventory;

  InventoryBalance({
     this.productId,
     this.productName,
     this.proInvId,
      this.inventoryType,
      this.qty,
      this.buyPrice,
      this.sellPrice,
      this.lastUpdated,
      this.invId,
      this.inventoryName,
      this.currentInventory,
  });

  // Factory method to create an instance from a Map (e.g., from JSON or DB)
  factory InventoryBalance.fromMap(Map<String, dynamic> map) {
    return InventoryBalance(
      productId: map['productId'] as int,
      productName: map['productName'] as String,
      proInvId: map['proInvId'] as int,
      inventoryType: map['inventoryType'] as String,
      qty: map['qty'] as int,
      buyPrice: (map['buyPrice'] as num).toDouble(),
      sellPrice: (map['sellPrice'] as num).toDouble(),
      lastUpdated: DateTime.parse(map['last_updated'] as String),
      invId: map['invId'] as int,
      inventoryName: map['inventoryName'] as String,
      currentInventory: map['currentInventory'] as int,
    );
  }

  // Convert the object back to a Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'proInvId': proInvId,
      'inventoryType': inventoryType,
      'qty': qty,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'last_updated': lastUpdated,
      'invId': invId,
      'inventoryName': inventoryName,
      'currentInventory': currentInventory,
    };
  }

  // copyWith method for immutability
  InventoryBalance copyWith({
    int? productId,
    String? productName,
    int? proInvId,
    String? inventoryType,
    int? qty,
    double? buyPrice,
    double? sellPrice,
    DateTime? lastUpdated,
    int? invId,
    String? inventoryName,
    int? currentInventory,
  }) {
    return InventoryBalance(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      proInvId: proInvId ?? this.proInvId,
      inventoryType: inventoryType ?? this.inventoryType,
      qty: qty ?? this.qty,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      invId: invId ?? this.invId,
      inventoryName: inventoryName ?? this.inventoryName,
      currentInventory: currentInventory ?? this.currentInventory,
    );
  }

  @override
  String toString() {
    return 'InventoryBalance(productId: $productId, productName: $productName, proInvId: $proInvId, inventoryType: $inventoryType, qty: $qty, buyPrice: $buyPrice, sellPrice: $sellPrice, lastUpdated: $lastUpdated, invId: $invId, inventoryName: $inventoryName, currentInventory: $currentInventory)';
  }
}
