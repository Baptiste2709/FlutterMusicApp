import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  
  @override
  List<Object> get props => [];
}

class SearchQueryEvent extends SearchEvent {
  final String query;
  
  const SearchQueryEvent(this.query);
  
  @override
  List<Object> get props => [query];
}

// Cette classe doit également étendre SearchEvent, pas SearchBaseEvent
class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}