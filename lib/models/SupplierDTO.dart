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
    print("================ start SupplierDTO.fromJson ===================");
    print("id: ${json['id']}, type: ${json['id'].runtimeType}");
    print("user_id: ${json['user_id']}, type: ${json['user_id'].runtimeType}");
    print("market_id: ${json['market_id']}, type: ${json['market_id'].runtimeType}");
    print("================ end SupplierDTO.fromJson ===================");

    return SupplierDTO(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      marketId: json['market_id'] != null ? int.tryParse(json['market_id'].toString()) : null,
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
      'user_dto': userDTO?.toJson(),
      'join_date': joinDate?.toIso8601String(),
    };
  }
}