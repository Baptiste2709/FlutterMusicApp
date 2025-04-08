import 'package:equatable/equatable.dart';

abstract class SearchBaseEvent extends Equatable {
  const SearchBaseEvent();
  
  @override
  List<Object> get props => [];
}

class SearchEvent extends SearchBaseEvent {
  final String query;
  
  const SearchEvent(this.query);
  
  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends SearchBaseEvent {
  const ClearSearchEvent();
}