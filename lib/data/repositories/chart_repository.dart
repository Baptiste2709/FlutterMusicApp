import '../../api/models/chart.dart';
import '../../api/services/chart_service.dart';

class ChartRepository {
  final ChartService _chartService;
  
  ChartRepository({required ChartService chartService})
      : _chartService = chartService;
  
  // Dans chart_repository.dart
  Future<ChartResponse> getCharts() async {
    try {
      // Corriger l'appel pour correspondre au nom exact de la méthode définie
      final chartResponse = await _chartService.getItunesCharts();
      return chartResponse;
    } catch (e) {
      throw Exception('Failed to load charts: $e');
    }
  }
}