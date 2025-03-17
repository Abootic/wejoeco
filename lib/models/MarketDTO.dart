class MarketDTO {
  final int? id;
  final String? name;

  MarketDTO({
    this.id,
    this.name,
  });

  factory MarketDTO.fromJson(Map<String, dynamic> json) {
    return MarketDTO(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  bool isValid() {
    return name != null && name!.isNotEmpty;
  }

  @override
  String toString() {
    return 'MarketDTO(id: $id, name: $name)';
  }
}
