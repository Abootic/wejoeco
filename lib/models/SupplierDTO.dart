import 'UserDTO.dart';

class SupplierDTO {
  final int? id;
  final int? userId;
  final int? marketId;
  final String? code;
  final UserDTO? userDTO;
  final DateTime? joinDate;

  SupplierDTO({
    this.id,
    this.userId,
    this.marketId,
    this.code,
    this.userDTO,
    this.joinDate,
  });

  factory SupplierDTO.fromJson(Map<String, dynamic> json) {
    return SupplierDTO(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      marketId: json['market_id'] as int?,
      code: json['code'] as String?,
      userDTO: json['user_dto'] != null ? UserDTO.fromJson(json['user_dto']) : null,
      joinDate: json['join_date'] != null ? DateTime.parse(json['join_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'market_id': marketId,
      'code': code,
      'user_dto': userDTO?.toJson(), // Ensure userDTO is not null before calling toJson()
      'join_date': joinDate?.toIso8601String(), // Handle null dates gracefully
    };
  }
}
