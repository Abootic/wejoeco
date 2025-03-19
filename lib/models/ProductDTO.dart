class ProductDTO {
  final int? id;
  final String? name;
  final double? price;  // Change this to double
  final int? supplierId;
  final String? image;

  ProductDTO({
    this.id,
    this.name,
    this.price,
    this.supplierId,
    this.image,
  });

  // Factory constructor to create a DTO from a JSON map
  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: json['price'] as double?, // Change to double
      supplierId: json['supplier_id'] as int?,
      image: json['image'] as String?,
    );
  }

  // Convert DTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'supplier_id': supplierId,
      'image': image,
    };
  }
}
