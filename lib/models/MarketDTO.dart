class MarketDTO {
  final int? id;
  final String? name;

  MarketDTO({
    this.id,
    this.name,
  });

  factory MarketDTO.fromJson(Map<String, dynamic> json) {
    // Check if 'name' exists and is not null
    final name = json['name'] != null ? json['name'] : "Unknown";  // Provide a fallback value if null

    return MarketDTO(
      id: json['id'] as int?,
      name: name,
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
