

import 'SupplierDTO.dart';

class SupplierProfitDTO {
  final SupplierDTO? supplier;
  final DateTime? month;
  final double? profit;

  SupplierProfitDTO({
    this.supplier,
    this.month,
    this.profit,
  });

  factory SupplierProfitDTO.fromJson(Map<String, dynamic> json) {
    return SupplierProfitDTO(
      supplier: json['supplier'] != null ? SupplierDTO.fromJson(json['supplier']) : null,
      month: json['month'] != null ? DateTime.parse(json['month']) : null,
      profit: (json['profit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier': supplier?.toJson(),
      'month': month?.toIso8601String(),
      'profit': profit?.toString(),
    };
  }
}
