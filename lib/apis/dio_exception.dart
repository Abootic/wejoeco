import 'package:dio/dio.dart';
import 'dart:io';

class NotSuccessException implements Exception {
  final String message;
  NotSuccessException.fromMessage(this.message);
}

class DioExceptions implements Exception {
  final String message;

  DioExceptions.fromDioError(DioException dioError)
      : message = _mapDioErrorToMessage(dioError);

  static String _mapDioErrorToMessage(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return "Request to API server was cancelled";

      case DioExceptionType.connectionTimeout:
        return "الانترنت ضعيف تم فقد الاتصال بالسرفر";

      case DioExceptionType.receiveTimeout:
        return "الإنترنت ضعيف تم فقد الاتصال بالسرفر اثناء استلام البيانات";

      case DioExceptionType.sendTimeout:
        return "الإنترنت ضعيف تم فقد الاتصال بالسرفر اثناء ارسال البيانات";

      case DioExceptionType.badResponse:
        return _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );

      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return 'لا يوجد انترنت';
        }
        return "حدث خطأ غير متوقع";

      default:
        return "حدث خطأ غير متوقع";
    }
  }

  static String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح';
      case 401:
        return 'غير مخول';
      case 403:
        return 'محظور';
      case 404:
        return error is Map && error.containsKey('Message')
            ? error['Message']
            : 'لم يتم العثور على المورد';
      case 500:
        return 'خطأ في الخادم الداخلي';
      case 502:
        return 'بوابة غير صالحة';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  @override
  String toString() => message;
}
