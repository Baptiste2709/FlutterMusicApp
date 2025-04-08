import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/repositories/artist_repository.dart';
import '../../../data/repositories/album_repository.dart';
import '../../../api/models/search_result.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ArtistRepository _artistRepository;
  final AlbumRepository _albumRepository;
  
  SearchBloc({
    required ArtistRepository artistRepository,
    required AlbumRepository albumRepository,
  })  : _artistRepository = artistRepository,
        _albumRepository = albumRepository,
        super(SearchInitialState()) {
    on<SearchEvent>(_onSearch, transformer: _debounce(const Duration(milliseconds: 300)));
    on<ClearSearchEvent>(_onClearSearch);
  }
  
  // Debounce event transformer to prevent excessive API calls while typing
  EventTransformer<SearchEvent> _debounce<SearchEvent>(Duration duration) {
    return (events, mapper) => events
        .where((event) => event is! ClearSearchEvent) // Don't debounce clear events
        .debounceTime(duration)
        .flatMap(mapper);
  }
  
  Future<void> _onSearch(SearchEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty || event.query.length < 3) {
      emit(SearchInitialState());
      return;
    }
    
    try {
      emit(SearchLoadingState());
      
      // Search for artists
      final artistResults = await _artistRepository.searchArtists(event.query);
      
      // For each artist, search for their albums
      final Map<String, dynamic> albumsResults = {};
      if (artistResults.artists != null && artistResults.artists!.isNotEmpty) {
        for (final artist in artistResults.artists!) {
          if (artist.id != null) {
            final albums = await _albumRepository.getArtistAlbums(artist.id!);
            albumsResults[artist.id!] = albums;
          }
        }
      }
      
      // Combine results
      final combinedResults = CombinedSearchResults.fromSearchResults(
        artistResults: artistResults,
        albumsResults: albumsResults,
      );
      
      emit(SearchLoadedState(results: combinedResults));
    } catch (error) {
      emit(SearchErrorState(message: 'Search failed: ${error.toString()}'));
    }
  }
  
  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitialState());
  }
}