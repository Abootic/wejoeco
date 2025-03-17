
class OrderDTO {
  final int? id;
  final int? customerId;
  final int? productId;
  final double? totalPrice;
  final double? price;
  final int? quantity;
  final DateTime? createdAt;

  OrderDTO({
    this.id,
    this.customerId,
    this.productId,
    this.totalPrice,
    this.price,
    this.quantity,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderDTO.fromJson(Map<String, dynamic> json) {
    return OrderDTO(
      id: json['id'] as int?,
      customerId: json['customer_id'] as int?,
      productId: json['product_id'] as int?,
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      createdAt: json['create_at'] != null ? DateTime.parse(json['create_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'total_price': totalPrice?.toString(),
      'price': price?.toString(),
      'quantity': quantity,
      'create_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'OrderDTO(id: $id, customerId: $customerId, productId: $productId, totalPrice: $totalPrice, price: $price, quantity: $quantity, createdAt: $createdAt)';
  }
}
