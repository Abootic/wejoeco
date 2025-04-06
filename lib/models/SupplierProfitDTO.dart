import 'SupplierDTO.dart';

class SupplierProfitDTO {
  final SupplierDTO? supplier;
  final DateTime? month;
  final double? profit;
  final int? id;
  final int? supplierId;

  SupplierProfitDTO({
    this.supplier,
    this.month,
    this.profit,
    this.id,
    this.supplierId,
  });

  factory SupplierProfitDTO.fromJson(Map<String, dynamic> json) {
    // Handle both nested 'profit_data' and root-level fields
    final profitData = json['profit_data'] ?? json;

    return SupplierProfitDTO(
      supplier: json['supplier'] != null
          ? SupplierDTO.fromJson(json['supplier'])
          : null,
      month: _parseDateTime(profitData['month']),
      profit: _parseDouble(profitData['profit']),
      id: _parseInt(profitData['id']),
      supplierId: _parseInt(profitData['supplier_id']),
    );
  }

  // Helper methods for safe parsing
  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier': supplier?.toJson(),
      'month': month?.toIso8601String(),
      'profit': profit,
      'id': id,
      'supplier_id': supplierId,
    };
  }
}