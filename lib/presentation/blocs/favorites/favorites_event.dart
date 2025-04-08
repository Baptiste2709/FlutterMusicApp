import 'package:equatable/equatable.dart';
import '../../../api/models/artist.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final Artist artist;
  
  const AddFavoriteEvent(this.artist);
  
  @override
  List<Object> get props => [artist];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String artistId;
  
  const RemoveFavoriteEvent(this.artistId);
  
  @override
  List<Object> get props => [artistId];
}

class CheckIsFavoriteEvent extends FavoritesEvent {
  final String artistId;
  
  const CheckIsFavoriteEvent(this.artistId);
  
  @override
  List<Object> get props => [artistId];
}