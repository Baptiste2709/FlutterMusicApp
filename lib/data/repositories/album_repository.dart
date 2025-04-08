import '../../api/client.dart';
import '../../api/models/album.dart';
import '../../api/models/search_result.dart';
import '../../core/exceptions/api_exception.dart';

class AlbumRepository {
  final ApiClient _apiClient = ApiClient();
  
  /// Récupère les détails d'un album par son ID
  Future<Album?> getAlbumById(String albumId) async {
    try {
      final response = await _apiClient.albumService.getAlbumById(albumId: albumId);
      if (response.albums != null && response.albums!.isNotEmpty) {
        return response.albums!.first;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load album: $e');
    }
  }
  
  /// Récupère tous les albums d'un artiste par son ID
  Future<List<Album>> getArtistAlbums(String artistId) async {
    try {
      final response = await _apiClient.albumService.getArtistAlbums(artistId: artistId);
      return response.albums ?? [];
    } catch (e) {
      throw Exception('Failed to load artist albums: $e');
    }
  }
  
  /// Recherche des albums par nom
  Future<List<Album>> searchAlbums(String query) async {
    try {
      final response = await _apiClient.albumService.searchAlbums(albumName: query);
      return response.albums ?? [];
    } catch (e) {
      throw Exception('Failed to search albums: $e');
    }
  }
}