import 'package:dio/dio.dart';
import 'interceptors/api_interceptor.dart';
import 'services/artist_service.dart';
import 'services/album_service.dart';
import 'services/chart_service.dart';
import '../core/constants/api_constants.dart';

class ApiClient {
  final Dio _dio;
  
  late final ArtistService artistService;
  late final AlbumService albumService;
  late final ChartService chartService;
  
  // Singleton
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  ApiClient._internal() : _dio = Dio() {
    _configureDio();
    _initializeServices();
  }
  
  void _configureDio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 8000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 8000);
    
    // Ajouter l'intercepteur
    _dio.interceptors.add(ApiInterceptor());
    
    // Ajouter un logger pour le débogage en mode développement
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  void _initializeServices() {
    artistService = ArtistService(_dio);
    albumService = AlbumService(_dio);
    chartService = ChartService(_dio);
  }
  
  // Getter pour accéder au Dio instance si nécessaire
  Dio get dio => _dio;
}