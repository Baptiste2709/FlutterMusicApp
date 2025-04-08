import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final RequestOptions requestOptions;

  ApiException({
    required this.message,
    required this.statusCode,
    required this.requestOptions,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}