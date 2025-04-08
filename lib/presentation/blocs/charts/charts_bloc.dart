import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/chart_repository.dart';
import 'charts_event.dart';
import 'charts_state.dart';

class ChartsBloc extends Bloc<ChartsEvent, ChartsState> {
  final ChartRepository _chartRepository;
  
  ChartsBloc({required ChartRepository chartRepository})
      : _chartRepository = chartRepository,
        super(ChartsInitialState()) {
    on<LoadChartsEvent>(_onLoadCharts);
  }
  
  Future<void> _onLoadCharts(LoadChartsEvent event, Emitter<ChartsState> emit) async {
    try {
      emit(ChartsLoadingState());
      final charts = await _chartRepository.getCharts();
      
      emit(ChartsLoadedState(
        tracks: charts.tracks,
        albums: charts.albums,
      ));
    } catch (error) {
      emit(ChartsErrorState(
        message: 'Failed to load charts: ${error.toString()}',
      ));
    }
  }
}