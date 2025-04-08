import 'package:equatable/equatable.dart';
import '../../../api/models/chart.dart';

abstract class ChartsState extends Equatable {
  const ChartsState();
  
  @override
  List<Object?> get props => [];
}

class ChartsInitialState extends ChartsState {}

class ChartsLoadingState extends ChartsState {}

class ChartsLoadedState extends ChartsState {
  final List<ChartItem>? tracks;
  final List<ChartItem>? albums;
  
  const ChartsLoadedState({
    this.tracks,
    this.albums,
  });
  
  @override
  List<Object?> get props => [tracks, albums];
}

class ChartsErrorState extends ChartsState {
  final String message;
  
  const ChartsErrorState({
    required this.message,
  });
  
  @override
  List<Object> get props => [message];
}