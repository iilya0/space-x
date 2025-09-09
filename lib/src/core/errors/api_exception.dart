import 'package:space_x/src/core/resources/app_exception_keys.dart';

class ApiException implements Exception {
  final String key;

  ApiException({this.key = AppExceptionKeys.httpError});

  @override
  String toString() {
    return '$key)';
  }
}
