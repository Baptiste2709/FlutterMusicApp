import '../../api/models/chart.dart';
import '../../api/services/chart_service.dart';

class ChartRepository {
  final ChartService _chartService;
  
  ChartRepository({required ChartService chartService})
      : _chartService = chartService;
  
  /// Récupère les classements de singles et d'albums depuis l'API
  Future<ChartResponse> getCharts() async {
    try {
      // Pour cet exercice, nous récupérons les charts US iTunes
      final chartResponse = await _chartService.getITunesCharts();
      return chartResponse;
    } catch (e) {
      throw Exception('Failed to load charts: $e');
    }
  }
}