import 'package:equatable/equatable.dart';
import '../../../api/models/search_result.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final CombinedSearchResults results;
  
  const SearchLoadedState({required this.results});
  
  @override
  List<Object> get props => [results];
}

class SearchErrorState extends SearchState {
  final String message;
  
  const SearchErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}