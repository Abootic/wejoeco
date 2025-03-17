
class PercentageDTO {
  final int? supplierId;
  final int? marketId;
  final int priority;
  final double percentageValue;

  PercentageDTO({
    this.supplierId,
    this.marketId,
    required this.priority,
    required this.percentageValue,
  });

  factory PercentageDTO.fromJson(Map<String, dynamic> json) {
    return PercentageDTO(
      supplierId: json['supplier_id'] as int?,
      marketId: json['market_id'] as int?,
      priority: json['priority'] as int,
      percentageValue: (json['percentage_value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier_id': supplierId,
      'market_id': marketId,
      'priority': priority,
      'percentage_value': percentageValue,
    };
  }

  @override
  String toString() {
    return 'PercentageDTO(supplierId: $supplierId, marketId: $marketId, priority: $priority, percentageValue: $percentageValue)';
  }
}
