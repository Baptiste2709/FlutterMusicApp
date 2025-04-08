import 'package:dio/dio.dart';
import '../../core/exceptions/api_exception.dart';

/// Intercepteur pour les requêtes et réponses API
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    
    // Créer une instance d'ApiException pour le logging ou autre traitement
    final apiException = ApiException(
      message: _getErrorMessage(err),
      statusCode: err.response?.statusCode ?? 0,
      requestOptions: err.requestOptions,
    );
    
    print(apiException.toString());
    
    // Continuer avec l'erreur d'origine
    handler.next(err);
  }
  
  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        if (statusCode == 401) {
          return 'Unauthorized. Please check your API token.';
        } else if (statusCode >= 500) {
          return 'Server error. Please try again later.';
        } else {
          return err.response?.statusMessage ?? 'Unknown error occurred';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error occurred';
    }
  }
}