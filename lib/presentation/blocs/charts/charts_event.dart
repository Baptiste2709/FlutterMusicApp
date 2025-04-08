import 'package:equatable/equatable.dart';

abstract class ChartsEvent extends Equatable {
  const ChartsEvent();
  
  @override
  List<Object> get props => [];
}

class LoadChartsEvent extends ChartsEvent {
  const LoadChartsEvent();
}

class RefreshChartsEvent extends ChartsEvent {
  const RefreshChartsEvent();
}