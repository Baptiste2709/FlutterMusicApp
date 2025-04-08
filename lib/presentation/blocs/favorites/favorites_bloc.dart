import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/models/artist.dart';
import '../../../data/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  
  FavoritesBloc({required FavoritesRepository favoritesRepository})
      : _favoritesRepository = favoritesRepository,
        super(FavoritesInitialState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }
  
  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(FavoritesLoadingState());
      final favorites =  _favoritesRepository.getFavoriteArtists();
      emit(FavoritesLoadedState(favorites: favorites));
    } catch (error) {
      emit(FavoritesErrorState(message: 'Failed to load favorites: ${error.toString()}'));
    }
  }
  
  Future<void> _onAddFavorite(AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      // Utilisation de toggleFavoriteArtist au lieu de addFavorite (inexistante)
      await _favoritesRepository.toggleFavoriteArtist(event.artist);
      final favorites =  _favoritesRepository.getFavoriteArtists();
      emit(FavoritesLoadedState(favorites: favorites));
    } catch (error) {
      emit(FavoritesErrorState(message: 'Failed to add to favorites: ${error.toString()}'));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      // Nous devons créer un Artist temporaire pour utiliser toggleFavoriteArtist
      final artist = Artist(id: event.artistId);
      await _favoritesRepository.toggleFavoriteArtist(artist);
      final favorites =  _favoritesRepository.getFavoriteArtists();
      emit(FavoritesLoadedState(favorites: favorites));
    } catch (error) {
      emit(FavoritesErrorState(message: 'Failed to remove from favorites: ${error.toString()}'));
    }
  }
}