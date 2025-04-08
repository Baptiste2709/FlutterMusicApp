import 'package:equatable/equatable.dart';
import '../../../api/models/artist.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<Artist> favorites;
  
  const FavoritesLoadedState({required this.favorites});
  
  @override
  List<Object> get props => [favorites];
  
  /// Check if an artist is in favorites
  bool isFavorite(String artistId) {
    return favorites.any((artist) => artist.id == artistId);
  }
}

class FavoritesErrorState extends FavoritesState {
  final String message;
  
  const FavoritesErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}