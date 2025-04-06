import 'SupplierDTO.dart';

import 'PercentageDTO.dart';
import 'SupplierProfitDTO.dart';

class SupplierProfitPercentageDTO {
  final SupplierDTO? supplier;
  final SupplierProfitDTO? profitData;
  final PercentageDTO? percentageData;

  SupplierProfitPercentageDTO({
    this.supplier,
    this.profitData,
    this.percentageData,
  });

  factory SupplierProfitPercentageDTO.fromJson(Map<String, dynamic> json) {
    // Helper function to parse profit data from different JSON structures
    SupplierProfitDTO? _parseProfitData(Map<String, dynamic> json) {
      // Case 1: Profit data is nested under 'profit_data'
      if (json['profit_data'] != null && json['profit_data'] is Map) {
        return SupplierProfitDTO.fromJson(json['profit_data']);
      }

      // Case 2: Profit fields are at root level
      if (json['profit'] != null) {
        return SupplierProfitDTO(
          id: json['id'] as int?,
          supplierId: json['supplier_id'] as int?,
          profit: (json['profit'] as num?)?.toDouble(),
          month: json['month'],
        );
      }

      // Case 3: No profit data available
      return null;
    }

    return SupplierProfitPercentageDTO(
      supplier: json['supplier'] != null
          ? SupplierDTO.fromJson(json['supplier'])
          : null,
      profitData: _parseProfitData(json),
      percentageData: json['percentage_data'] != null
          ? PercentageDTO.fromJson(json['percentage_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier': supplier?.toJson(),
      'profit_data': profitData?.toJson(),
      'percentage_data': percentageData?.toJson(),
    };
  }
}
