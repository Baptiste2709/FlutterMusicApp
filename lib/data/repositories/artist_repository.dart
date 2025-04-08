import '../../api/client.dart';
import '../../api/models/artist.dart';
import '../../api/models/search_result.dart';
import '../../core/exceptions/api_exception.dart';

class ArtistRepository {
  final ApiClient _apiClient = ApiClient();
  
  /// Récupère les détails d'un artiste par son ID
  Future<Artist?> getArtistById(String artistId) async {
    try {
      final response = await _apiClient.artistService.getArtistById(artistId: artistId);
      if (response.artists != null && response.artists!.isNotEmpty) {
        return response.artists!.first;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load artist: $e');
    }
  }
  
  /// Recherche des artistes par nom
  Future<List<Artist>> searchArtists(String query) async {
    try {
      final response = await _apiClient.artistService.searchArtists(artistName: query);
      return response.artists ?? [];
    } catch (e) {
      throw Exception('Failed to search artists: $e');
    }
  }
  
  /// Recherche combinée d'artistes et d'albums
  Future<CombinedSearchResults> performCombinedSearch(String query) async {
    try {
      // Recherche des artistes
      final artistResult = await _apiClient.artistService.searchArtists(artistName: query);
      
      // Pour chaque artiste trouvé, on cherche ses albums
      final Map<String, List<Album>> albumsByArtist = {};
      
      if (artistResult.artists != null) {
        for (var artist in artistResult.artists!) {
          if (artist.id != null) {
            try {
              final albumResponse = await _apiClient.albumService.getArtistAlbums(artistId: artist.id!);
              if (albumResponse.albums != null) {
                albumsByArtist[artist.id!] = albumResponse.albums!;
              }
            } catch (e) {
              print('Error fetching albums for artist ${artist.name}: $e');
            }
          }
        }
      }
      
      return CombinedSearchResults(
        artists: artistResult.artists ?? [],
        albumsByArtist: albumsByArtist,
      );
    } catch (e) {
      print('Error in combined search: $e');
      return CombinedSearchResults(artists: [], albumsByArtist: {});
    }
  }
}