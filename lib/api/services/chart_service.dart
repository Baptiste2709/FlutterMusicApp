import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/chart.dart';
import '../../core/constants/api_constants.dart';

part 'chart_service.g.dart';

@RestApi()
abstract class ChartService {
  factory ChartService(Dio dio, {String baseUrl}) = _ChartService;
  
  /// Récupère les classements iTunes pour un pays
  @GET('/trending.php')
  Future<ChartResponse> getItunesCharts({
    @Query('country') String country = ApiConstants.countryUS,
    @Query('type') String type = ApiConstants.typeITunes,
  });
}