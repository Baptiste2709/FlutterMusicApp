import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _albumRepository;
  
  AlbumBloc({required AlbumRepository albumRepository})
      : _albumRepository = albumRepository,
        super(AlbumInitialState()) {
    on<LoadAlbumEvent>(_onLoadAlbum);
  }
  
  Future<void> _onLoadAlbum(LoadAlbumEvent event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoadingState());
      
      final album = await _albumRepository.getAlbumById(event.albumId);
      
      if (album == null) {
        emit(const AlbumErrorState(message: 'Album not found'));
        return;
      }
      
      emit(AlbumLoadedState(album: album));
    } catch (error) {
      emit(AlbumErrorState(message: 'Failed to load album: ${error.toString()}'));
    }
  }
}