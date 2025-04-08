import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/repositories/artist_repository.dart';
import '../../../data/repositories/album_repository.dart';
import '../../../api/models/search_result.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../../api/models/album.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ArtistRepository _artistRepository;
  final AlbumRepository _albumRepository;
  
  SearchBloc({
    required ArtistRepository artistRepository,
    required AlbumRepository albumRepository,
  })  : _artistRepository = artistRepository,
        _albumRepository = albumRepository,
        super(SearchInitialState()) {
    on<SearchQueryEvent>(_onSearch, transformer: _debounce(const Duration(milliseconds: 300)));
    on<ClearSearchEvent>(_onClearSearch);
  }
  
  // Debounce event transformer to prevent excessive API calls while typing
  EventTransformer<E> _debounce<E extends SearchEvent>(Duration duration) {
    return (events, mapper) => events
        .where((event) => event is! ClearSearchEvent) // Don't debounce clear events
        .debounceTime(duration)
        .flatMap(mapper);
  }
  
Future<void> _onSearch(SearchQueryEvent event, Emitter<SearchState> emit) async {
  if (event.query.isEmpty || event.query.length < 3) {
    emit(SearchInitialState());
    return;
  }
  
  try {
    emit(SearchLoadingState());
    
    // Search for artists
    final artistResults = await _artistRepository.searchArtists(event.query);
    
    // For each artist, search for their albums
    final Map<String, List<Album>> albumsByArtist = {};
    if (artistResults.isNotEmpty) {
      for (final artist in artistResults) {
        if (artist.id != null) {
          final albumsResult = await _albumRepository.getArtistAlbums(artist.id!);
          albumsByArtist[artist.id!] = albumsResult;
        }
      }
    }
    
    // Combine results
    final combinedResults = CombinedSearchResults(
      artists: artistResults,
      albumsByArtist: albumsByArtist,
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