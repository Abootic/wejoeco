import 'UserDTO.dart';

class CustomerDTO {
  final int? id;
  final int? userId;
  final String? code;
  final String? phoneNumber;
  final UserDTO?  userDto;

  CustomerDTO({
    this.id,
    this.userId,
    this.code,
    this.phoneNumber,
    this.userDto,
  });

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDTO(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      code: json['code'] as String?,
      phoneNumber: json['phone_number'] as String?,
      userDto: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'phone_number': phoneNumber,
      'user': userDto?.toJson(),
    };
  }

  @override
  String toString() {
    return 'CustomerDTO(id: $id, userId: $userId, code: $code, phoneNumber: $phoneNumber, userDto: $userDto)';
  }
}


