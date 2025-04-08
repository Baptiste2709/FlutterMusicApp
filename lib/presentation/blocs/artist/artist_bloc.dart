import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/models/artist.dart';
import '../../../api/models/album.dart';
import '../../../data/repositories/artist_repository.dart';
import '../../../data/repositories/album_repository.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistRepository _artistRepository;
  final AlbumRepository _albumRepository;
  
  ArtistBloc({
    required ArtistRepository artistRepository,
    required AlbumRepository albumRepository,
  })  : _artistRepository = artistRepository,
        _albumRepository = albumRepository,
        super(ArtistInitialState()) {
    on<LoadArtistEvent>(_onLoadArtist);
  }
  
  Future<void> _onLoadArtist(LoadArtistEvent event, Emitter<ArtistState> emit) async {
    try {
      emit(ArtistLoadingState());
      
      // Charger les détails de l'artiste
      final artist = await _artistRepository.getArtistById(event.artistId);
      
      if (artist == null) {
        emit(const ArtistErrorState(message: 'Artist not found'));
        return;
      }
      
      // Charger les albums de l'artiste
      final albumsResult = await _albumRepository.getArtistAlbums(event.artistId);
      final albums = albumsResult.albums ?? [];
      
      emit(ArtistLoadedState(artist: artist, albums: albums));
    } catch (error) {
      emit(ArtistErrorState(message: 'Failed to load artist: ${error.toString()}'));
    }
  }
}